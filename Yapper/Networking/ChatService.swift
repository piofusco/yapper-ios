//
//  ChatService.swift
//  Yapper
//
//  Created by Michael Pace on 6/6/26.
//

import Foundation
import Observation
import OSLog

private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Yapper", category: "WebSocket")

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
    private let encoder: any ScaffoldJSONEncoder
    private let decoder: any ScaffoldJSONDecoder
    private var listeningTask: Task<Void, Never>?

    init(
        webSocketClient: any WebSocketClient = DefaultWebSocketClient(session: URLSession.shared),
        encoder: any ScaffoldJSONEncoder = JSONEncoder(),
        decoder: any ScaffoldJSONDecoder = JSONDecoder()
    ) {
        self.webSocketClient = webSocketClient
        self.encoder = encoder
        self.decoder = decoder
    }

    func connect(
        token: String
    ) async throws {
        let url = YapperEndpoint.webSocket.url
        logger.debug("→ WS connect \(url.absoluteString)")
        try await webSocketClient.connect(to: url)
        logger.debug("← WS connected")
        startListening()
        let auth = OutgoingAuth(token: token)
        let json = try encoder.encode(auth)
        guard let jsonString = String(data: json, encoding: .utf8) else { return }
        logger.debug("→ WS send: \(jsonString)")
        try await webSocketClient.send(.text(jsonString))
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
        let json = try encoder.encode(dm)
        guard let jsonString = String(data: json, encoding: .utf8) else { return }
        logger.debug("→ WS send: \(jsonString)")
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
              let envelope = try? decoder.decode(IncomingEnvelope.self, from: data) else { return }
        logger.debug("← WS recv [\(envelope.type)]: \(json)")
        switch envelope.type {
        case "dm":
            guard let dm = try? decoder.decode(IncomingDM.self, from: data) else {
                logger.error("← WS failed to decode dm")
                return
            }
            messages.append(ChatMessage(
                text: dm.text,
                partner: dm.from,
                isSent: false,
                timestamp: Date(timeIntervalSince1970: TimeInterval(dm.ts) / 1000)
            ))
        case "auth_ok":
            guard let msg = try? decoder.decode(IncomingAuthOK.self, from: data) else {
                logger.error("← WS failed to decode auth_ok")
                return
            }
            logger.debug("← WS auth_ok — \(msg.friends.count) friends")
            friends = msg.friends.map { Friend(username: $0.username, online: $0.online) }
        case "friends":
            guard let msg = try? decoder.decode(IncomingFriendsMessage.self, from: data) else {
                logger.error("← WS failed to decode friends")
                return
            }
            friends = msg.friends.map { Friend(username: $0.username, online: $0.online) }
        default:
            logger.debug("← WS unhandled type: \(envelope.type)")
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
