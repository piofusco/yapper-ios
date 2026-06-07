//
//  MockWebSocketTask.swift
//  BurrwTests
//
//  Created by Michael Pace on 6/5/26.
//

import Foundation
@testable import Burrw

final class MockWebSocketTask: ScaffoldWebSocketTask, @unchecked Sendable {
    var sendInvocations = 0
    var lastSentMessages = [URLSessionWebSocketTask.Message]()
    func send(_ message: URLSessionWebSocketTask.Message) async throws {
        sendInvocations += 1
        lastSentMessages.append(message)
    }

    var nextMessages = [Result<URLSessionWebSocketTask.Message, Error>]()
    func receive() async throws -> URLSessionWebSocketTask.Message {
        guard !nextMessages.isEmpty else {
            try await Task.sleep(for: .seconds(3600))
            throw NSError(domain: "MockWebSocketTask: unreachable", code: -1)
        }
        return try nextMessages.removeFirst().get()
    }

    var resumeInvocations = 0
    func resume() {
        resumeInvocations += 1
    }

    var cancelInvocations = 0
    var lastCancelCloseCodes = [URLSessionWebSocketTask.CloseCode]()
    func cancel(with closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        cancelInvocations += 1
        lastCancelCloseCodes.append(closeCode)
    }
}
