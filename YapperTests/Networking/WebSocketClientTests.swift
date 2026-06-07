//
//  WebSocketClientTests.swift
//  YapperTests
//
//  Created by Michael Pace on 6/5/26.
//

import Foundation
import Testing
@testable import Yapper

@MainActor
@Suite("WebSocketClient")
struct WebSocketClientTests {

    @MainActor
    @Suite("connect(to:)")
    struct Connect {
        private let subject: DefaultWebSocketClient
        private let mockSession: MockWebSocketSession
        private let mockTask: MockWebSocketTask
        private let testURL = URL(string: "wss://example.com")!

        init() {
            mockTask = MockWebSocketTask()
            mockSession = MockWebSocketSession(taskToReturn: mockTask)
            subject = DefaultWebSocketClient(session: mockSession)
        }

        @Test
        func `transitions to connected`() async throws {
            try await subject.connect(to: testURL)
            #expect(await subject.connectionState == .connected)
        }

        @Test
        func `resumes the WebSocket task`() async throws {
            try await subject.connect(to: testURL)
            #expect(mockTask.resumeInvocations == 1)
        }

        @Test
        func `creates one WebSocket task`() async throws {
            try await subject.connect(to: testURL)
            #expect(mockSession.makeWebSocketTaskInvocations == 1)
        }

        @Test
        func `no-op when already connected`() async throws {
            try await subject.connect(to: testURL)
            try await subject.connect(to: testURL)
            #expect(mockSession.makeWebSocketTaskInvocations == 1)
        }
    }

    @MainActor
    @Suite("disconnect()")
    struct Disconnect {
        private let subject: DefaultWebSocketClient
        private let mockSession: MockWebSocketSession
        private let mockTask: MockWebSocketTask
        private let testURL = URL(string: "wss://example.com")!

        init() {
            mockTask = MockWebSocketTask()
            mockSession = MockWebSocketSession(taskToReturn: mockTask)
            subject = DefaultWebSocketClient(session: mockSession)
        }

        @Test
        func `transitions to disconnected`() async throws {
            try await subject.connect(to: testURL)
            await subject.disconnect()
            #expect(await subject.connectionState == .disconnected)
        }

        @Test
        func `cancels the WebSocket task with normal closure`() async throws {
            try await subject.connect(to: testURL)
            await subject.disconnect()
            #expect(mockTask.cancelInvocations == 1)
            #expect(mockTask.lastCancelCloseCodes.last == .normalClosure)
        }

        @Test
        func `finishes messages stream`() async throws {
            try await subject.connect(to: testURL)
            await subject.disconnect()

            var count = 0
            for try await _ in await subject.messages { count += 1 }
            #expect(count == 0)
        }
    }

    @MainActor
    @Suite("send(_:)")
    struct Send {
        private let subject: DefaultWebSocketClient
        private let mockSession: MockWebSocketSession
        private let mockTask: MockWebSocketTask
        private let testURL = URL(string: "wss://example.com")!

        init() {
            mockTask = MockWebSocketTask()
            mockSession = MockWebSocketSession(taskToReturn: mockTask)
            subject = DefaultWebSocketClient(session: mockSession)
        }

        @Test
        func `sends text message to task`() async throws {
            try await subject.connect(to: testURL)
            try await subject.send(.text("Hello"))

            #expect(mockTask.sendInvocations == 1)
            let sent = try #require(mockTask.lastSentMessages.last)
            guard case .string(let text) = sent else {
                Issue.record("Expected .string message")
                return
            }
            #expect(text == "Hello")
        }

        @Test
        func `sends data message to task`() async throws {
            let data = Data([0x01, 0x02, 0x03])
            try await subject.connect(to: testURL)
            try await subject.send(.data(data))

            #expect(mockTask.sendInvocations == 1)
            let sent = try #require(mockTask.lastSentMessages.last)
            guard case .data(let sentData) = sent else {
                Issue.record("Expected .data message")
                return
            }
            #expect(sentData == data)
        }

        @Test
        func `throws disconnected when not connected`() async throws {
            await #expect(throws: NetworkError.disconnected) {
                try await subject.send(.text("Hello"))
            }
        }
    }

    @MainActor
    @Suite("messages")
    struct Messages {
        private let subject: DefaultWebSocketClient
        private let mockSession: MockWebSocketSession
        private let mockTask: MockWebSocketTask
        private let testURL = URL(string: "wss://example.com")!

        init() {
            mockTask = MockWebSocketTask()
            mockSession = MockWebSocketSession(taskToReturn: mockTask)
            subject = DefaultWebSocketClient(session: mockSession)
        }

        @Test
        func `text message appears in stream`() async throws {
            mockTask.nextMessages = [.success(.string("Hello"))]
            try await subject.connect(to: testURL)

            var received = [WebSocketMessage]()
            for try await message in await subject.messages {
                received.append(message)
                break
            }

            #expect(received == [.text("Hello")])
        }

        @Test
        func `data message appears in stream`() async throws {
            let data = Data([0x01, 0x02])
            mockTask.nextMessages = [.success(.data(data))]
            try await subject.connect(to: testURL)

            var received = [WebSocketMessage]()
            for try await message in await subject.messages {
                received.append(message)
                break
            }

            #expect(received == [.data(data)])
        }

        @Test
        func `task error finishes stream with error and disconnects`() async throws {
            let testError = NSError(domain: "test.error", code: -1)
            mockTask.nextMessages = [.failure(testError)]
            try await subject.connect(to: testURL)

            var didThrow = false
            do {
                for try await _ in await subject.messages {}
            } catch {
                didThrow = true
            }

            #expect(didThrow)
            #expect(await subject.connectionState == .disconnected)
        }
    }
}
