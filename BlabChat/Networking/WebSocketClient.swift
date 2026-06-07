//
//  WebSocketClient.swift
//  BlabChat
//
//  Created by Michael Pace on 6/5/26.
//

import Foundation

enum WebSocketMessage: Equatable {
    case text(String)
    case data(Data)
}

enum WebSocketConnectionState: Equatable {
    case connecting
    case connected
    case disconnected
}

protocol WebSocketClient: AnyObject, Sendable {
    var connectionState: WebSocketConnectionState { get async }
    var messages: AsyncThrowingStream<WebSocketMessage, Error> { get }

    func connect(
        to url: URL
    ) async throws
    func disconnect() async
    func send(
        _ message: WebSocketMessage
    ) async throws
}

actor DefaultWebSocketClient: WebSocketClient {
    private(set) var connectionState: WebSocketConnectionState = .disconnected

    private var task: (any ScaffoldWebSocketTask)?
    private var receiveTask: Task<Void, Never>?

    private let session: any ScaffoldWebSocketSession
    let messages: AsyncThrowingStream<WebSocketMessage, Error>
    private let messagesContinuation: AsyncThrowingStream<WebSocketMessage, Error>.Continuation

    init(
        session: any ScaffoldWebSocketSession
    ) {
        self.session = session

        (messages, messagesContinuation) = AsyncThrowingStream.makeStream(of: WebSocketMessage.self)
    }

    deinit {
        receiveTask?.cancel()
        task?.cancel(with: .normalClosure, reason: nil)
    }

    func connect(
        to url: URL
    ) async throws {
        guard connectionState == .disconnected else { return }
        connectionState = .connecting
        let wsTask = session.makeWebSocketTask(with: url)
        task = wsTask
        wsTask.resume()
        connectionState = .connected
        startReceiving(wsTask)
    }

    func disconnect() {
        receiveTask?.cancel()
        receiveTask = nil
        task?.cancel(with: .normalClosure, reason: nil)
        task = nil
        connectionState = .disconnected
        messagesContinuation.finish()
    }

    func send(
        _ message: WebSocketMessage
    ) async throws {
        guard let task else { throw NetworkError.disconnected }
        try await task.send(message.asURLSessionMessage)
    }

    private func startReceiving(
        _ wsTask: any ScaffoldWebSocketTask
    ) {
        let continuation = messagesContinuation
        receiveTask = Task { [weak self] in
            do {
                while !Task.isCancelled {
                    let rawMessage = try await wsTask.receive()
                    switch rawMessage {
                    case .string(let text): continuation.yield(.text(text))
                    case .data(let data): continuation.yield(.data(data))
                    @unknown default: break
                    }
                }
            } catch {
                guard !Task.isCancelled else { return }
                continuation.finish(throwing: error)
                if let self { await self.markDisconnected() }
            }
        }
    }

    private func markDisconnected() {
        connectionState = .disconnected
    }
}

private extension WebSocketMessage {
    var asURLSessionMessage: URLSessionWebSocketTask.Message {
        switch self {
        case .text(let text): .string(text)
        case .data(let data): .data(data)
        }
    }
}
