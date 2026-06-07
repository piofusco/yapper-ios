//
//  MockWebSocketClient.swift
//  YapperTests
//
//  Created by Michael Pace on 6/5/26.
//

import Foundation
@testable import Yapper

@MainActor
final class MockWebSocketClient: WebSocketClient {
    var connectionState: WebSocketConnectionState = .disconnected
    let messages: AsyncThrowingStream<WebSocketMessage, Error>

    init() {
        (messages, _) = AsyncThrowingStream.makeStream(of: WebSocketMessage.self)
    }

    var connectInvocations = 0
    var lastConnectURLs = [URL]()
    var connectError: Error?
    func connect(to url: URL) async throws {
        connectInvocations += 1
        lastConnectURLs.append(url)
        if let connectError { throw connectError }
        connectionState = .connected
    }

    var disconnectInvocations = 0
    func disconnect() {
        disconnectInvocations += 1
        connectionState = .disconnected
    }

    var sendInvocations = 0
    var lastSentMessages = [WebSocketMessage]()
    var sendError: Error?
    func send(_ message: WebSocketMessage) async throws {
        sendInvocations += 1
        lastSentMessages.append(message)
        if let sendError { throw sendError }
    }
}
