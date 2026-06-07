//
//  ChatServiceTests.swift
//  BurrwTests
//
//  Created by Michael Pace on 6/7/26.
//

import Foundation
import Testing
@testable import Burrw

@MainActor
@Suite("DefaultChatService")
struct ChatServiceTests {

    private func makeSubject(
        webSocketClient: MockWebSocketClient? = nil
    ) -> DefaultChatService {
        DefaultChatService(
            webSocketClient: webSocketClient ?? MockWebSocketClient(),
            logger: MockLogger()
        )
    }

    // MARK: - connect(token:)

    @Test
    func `connect - calls webSocketClient connect`() async throws {
        let mockWS = MockWebSocketClient()
        let subject = makeSubject(webSocketClient: mockWS)

        try await subject.connect(token: "test-token")

        #expect(mockWS.connectInvocations == 1)
    }

    @Test
    func `connect - sends auth message with token`() async throws {
        let mockWS = MockWebSocketClient()
        let subject = makeSubject(webSocketClient: mockWS)

        try await subject.connect(token: "test-token")

        guard case .text(let json) = mockWS.lastSentMessages.last else {
            Issue.record("Expected a text WebSocket message")
            return
        }
        #expect(json.contains("\"type\":\"auth\""))
        #expect(json.contains("\"token\":\"test-token\""))
    }

    @Test
    func `connect - webSocketClient throws - rethrows`() async {
        let mockWS = MockWebSocketClient()
        mockWS.connectError = NetworkError.internalError
        let subject = makeSubject(webSocketClient: mockWS)

        await #expect(throws: NetworkError.internalError) {
            try await subject.connect(token: "test-token")
        }
    }

    // MARK: - send(text:to:)

    @Test
    func `send - appends message to messages immediately`() async throws {
        let mockWS = MockWebSocketClient()
        let subject = makeSubject(webSocketClient: mockWS)
        try await subject.connect(token: "t")

        try await subject.send(text: "hello", to: "pace")

        #expect(subject.messages.count == 1)
        #expect(subject.messages.first?.text == "hello")
        #expect(subject.messages.first?.partner == "pace")
        #expect(subject.messages.first?.isSent == true)
    }

    @Test
    func `send - sends websocket message with correct content`() async throws {
        let mockWS = MockWebSocketClient()
        let subject = makeSubject(webSocketClient: mockWS)
        try await subject.connect(token: "t")

        try await subject.send(text: "hello", to: "pace")

        guard case .text(let json) = mockWS.lastSentMessages.last else {
            Issue.record("Expected a text WebSocket message")
            return
        }
        #expect(json.contains("\"text\":\"hello\""))
        #expect(json.contains("\"to\":\"pace\""))
        #expect(json.contains("\"type\":\"dm\""))
    }

    @Test
    func `send - webSocketClient throws - message stays in list`() async throws {
        let mockWS = MockWebSocketClient()
        let subject = makeSubject(webSocketClient: mockWS)
        try await subject.connect(token: "t")
        mockWS.sendError = NetworkError.disconnected

        try? await subject.send(text: "hello", to: "pace")

        #expect(subject.messages.count == 1)
    }

    // MARK: - disconnect()

    @Test
    func `disconnect - calls webSocketClient disconnect`() async throws {
        let mockWS = MockWebSocketClient()
        let subject = makeSubject(webSocketClient: mockWS)
        try await subject.connect(token: "t")

        await subject.disconnect()

        #expect(mockWS.disconnectInvocations == 1)
    }

    @Test
    func `disconnect - clears messages, friends, and current user`() async throws {
        let mockWS = MockWebSocketClient()
        let subject = makeSubject(webSocketClient: mockWS)
        try await subject.connect(token: "t")

        mockWS.yield(.text("""
        {"type":"auth_ok","user":"me","friends":[{"username":"pace","online":true}],"parties":[],"invites":[]}
        """))
        mockWS.yield(.text("""
        {"type":"dm","text":"hey","from":"pace","ts":1780809461101}
        """))
        await Task.yield()
        await Task.yield()

        await subject.disconnect()

        #expect(subject.messages.isEmpty)
        #expect(subject.friends.isEmpty)
    }

    // MARK: - Incoming messages

    @Test
    func `auth_ok - populates friends`() async throws {
        let mockWS = MockWebSocketClient()
        let subject = makeSubject(webSocketClient: mockWS)
        try await subject.connect(token: "t")

        mockWS.yield(.text("""
        {"type":"auth_ok","user":"me","friends":[{"username":"pace","online":true},{"username":"bird","online":false}],"parties":[],"invites":[]}
        """))
        await Task.yield()

        #expect(subject.friends.count == 2)
        #expect(subject.friends.contains { $0.username == "pace" && $0.online == true })
        #expect(subject.friends.contains { $0.username == "bird" && $0.online == false })
    }

    @Test
    func `auth_ok - excludes current user from friends`() async throws {
        let mockWS = MockWebSocketClient()
        let subject = makeSubject(webSocketClient: mockWS)
        try await subject.connect(token: "t")

        mockWS.yield(.text("""
        {"type":"auth_ok","user":"me","friends":[{"username":"pace","online":true},{"username":"me","online":true}],"parties":[],"invites":[]}
        """))
        await Task.yield()

        #expect(subject.friends.count == 1)
        #expect(subject.friends.first?.username == "pace")
    }

    @Test
    func `dm - appends received message`() async throws {
        let mockWS = MockWebSocketClient()
        let subject = makeSubject(webSocketClient: mockWS)
        try await subject.connect(token: "t")

        mockWS.yield(.text("""
        {"type":"dm","text":"hey there","from":"pace","ts":1780809461101}
        """))
        await Task.yield()

        #expect(subject.messages.count == 1)
        #expect(subject.messages.first?.text == "hey there")
        #expect(subject.messages.first?.partner == "pace")
        #expect(subject.messages.first?.isSent == false)
    }

    @Test
    func `friends update - replaces friends list excluding current user`() async throws {
        let mockWS = MockWebSocketClient()
        let subject = makeSubject(webSocketClient: mockWS)
        try await subject.connect(token: "t")

        mockWS.yield(.text("""
        {"type":"auth_ok","user":"me","friends":[],"parties":[],"invites":[]}
        """))
        await Task.yield()

        mockWS.yield(.text("""
        {"type":"friends","friends":[{"username":"pace","online":true},{"username":"me","online":true}]}
        """))
        await Task.yield()

        #expect(subject.friends.count == 1)
        #expect(subject.friends.first?.username == "pace")
    }

    // MARK: - Ping

    @Test
    func `ping - sends ping message after interval`() async throws {
        let mockWS = MockWebSocketClient()
        let subject = DefaultChatService(
            webSocketClient: mockWS,
            logger: MockLogger(),
            pingInterval: .milliseconds(50)
        )
        try await subject.connect(token: "t")

        try await Task.sleep(for: .milliseconds(100))

        let sentPings = mockWS.lastSentMessages.filter {
            if case .text(let json) = $0 { return json.contains("\"type\":\"ping\"") }
            return false
        }
        #expect(!sentPings.isEmpty)
    }

    @Test
    func `disconnect - cancels ping task`() async throws {
        let mockWS = MockWebSocketClient()
        let subject = DefaultChatService(
            webSocketClient: mockWS,
            logger: MockLogger(),
            pingInterval: .milliseconds(50)
        )
        try await subject.connect(token: "t")
        await subject.disconnect()
        let countAfterDisconnect = mockWS.sendInvocations

        try await Task.sleep(for: .milliseconds(150))

        #expect(mockWS.sendInvocations == countAfterDisconnect)
    }

    @Test
    func `pong - does not crash`() async throws {
        let mockWS = MockWebSocketClient()
        let subject = makeSubject(webSocketClient: mockWS)
        try await subject.connect(token: "t")

        mockWS.yield(.text("""
        {"type":"pong"}
        """))
        await Task.yield()

        #expect(subject.messages.isEmpty)
        #expect(subject.friends.isEmpty)
    }

    @Test
    func `unknown message type - does not crash`() async throws {
        let mockWS = MockWebSocketClient()
        let subject = makeSubject(webSocketClient: mockWS)
        try await subject.connect(token: "t")

        mockWS.yield(.text("""
        {"type":"unknown","data":"whatever"}
        """))
        await Task.yield()

        #expect(subject.messages.isEmpty)
        #expect(subject.friends.isEmpty)
    }
}
