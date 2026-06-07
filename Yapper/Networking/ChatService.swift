//
//  ChatService.swift
//  Yapper
//
//  Created by Michael Pace on 6/6/26.
//

import Foundation
import Observation

@MainActor
protocol ChatService: AnyObject {
    var messages: [ChatMessage] { get }
    var friends: [Friend] { get }

    func connect(
        token: String
    ) async throws
    func send(
        text: String,
        to recipient: String
    ) async throws
    func disconnect() async
}

@Observable
@MainActor
final class DefaultChatService: ChatService {
    private(set) var messages: [ChatMessage] = []
    private(set) var friends: [Friend] = []

    nonisolated private let webSocketClient: any WebSocketClient
    private var listeningTask: Task<Void, Never>?

    init(
        webSocketClient: any WebSocketClient = DefaultWebSocketClient(session: URLSession.shared)
    ) {
        self.webSocketClient = webSocketClient
    }

    func connect(
        token: String
    ) async throws {
        try await webSocketClient.connect(to: YapperEndpoint.webSocket(token: token).url)
        startListening()
    }

    func send(
        text: String,
        to recipient: String
    ) async throws {
        let dm = OutgoingDM(
            text: text,
            to: recipient,
            ts: Int64(Date().timeIntervalSince1970 * 1000)
        )
        let json = try JSONEncoder().encode(dm)
        guard let jsonString = String(data: json, encoding: .utf8) else { return }
        try await webSocketClient.send(.text(jsonString))
        messages.append(ChatMessage(
            text: text,
            partner: recipient,
            isSent: true,
            timestamp: Date()
        ))
    }

    func disconnect() async {
        listeningTask?.cancel()
        listeningTask = nil
        await webSocketClient.disconnect()
    }

    private func startListening() {
        let stream = webSocketClient.messages
        listeningTask = Task { [weak self] in
            do {
                for try await message in stream {
                    self?.handle(message)
                }
            } catch {
                self?.markDisconnected()
            }
        }
    }

    private func handle(_ message: WebSocketMessage) {
        guard case .text(let json) = message,
              let data = json.data(using: .utf8),
              let envelope = try? JSONDecoder().decode(IncomingEnvelope.self, from: data) else { return }
        switch envelope.type {
        case "dm":
            guard let dm = try? JSONDecoder().decode(IncomingDM.self, from: data) else { return }
            messages.append(ChatMessage(
                text: dm.text,
                partner: dm.from,
                isSent: false,
                timestamp: Date(timeIntervalSince1970: TimeInterval(dm.ts) / 1000)
            ))
        case "friends":
            guard let msg = try? JSONDecoder().decode(IncomingFriendsMessage.self, from: data) else { return }
            friends = msg.friends.map { Friend(username: $0.username, online: $0.online) }
        default:
            break
        }
    }

    private func markDisconnected() {
        listeningTask = nil
    }
}

private struct IncomingEnvelope: Decodable {
    let type: String
}
