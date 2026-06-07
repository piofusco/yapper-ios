//
//  ScaffoldWebSocketSession.swift
//  Burrw
//
//  Created by Michael Pace on 6/5/26.
//

import Foundation

protocol ScaffoldWebSocketTask: Sendable {
    func send(_ message: URLSessionWebSocketTask.Message) async throws
    func receive() async throws -> URLSessionWebSocketTask.Message
    func resume()
    func cancel(with closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?)
}

extension URLSessionWebSocketTask: ScaffoldWebSocketTask {}

protocol ScaffoldWebSocketSession {
    func makeWebSocketTask(with url: URL) -> any ScaffoldWebSocketTask
}

extension URLSession: ScaffoldWebSocketSession {
    func makeWebSocketTask(with url: URL) -> any ScaffoldWebSocketTask {
        webSocketTask(with: url)
    }
}
