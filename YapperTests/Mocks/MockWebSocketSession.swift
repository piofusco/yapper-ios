//
//  MockWebSocketSession.swift
//  YapperTests
//
//  Created by Michael Pace on 6/5/26.
//

import Foundation
@testable import Yapper

final class MockWebSocketSession: ScaffoldWebSocketSession {
    var makeWebSocketTaskInvocations = 0
    var taskToReturn: MockWebSocketTask

    init(taskToReturn: MockWebSocketTask = MockWebSocketTask()) {
        self.taskToReturn = taskToReturn
    }

    func makeWebSocketTask(with url: URL) -> any ScaffoldWebSocketTask {
        makeWebSocketTaskInvocations += 1
        return taskToReturn
    }
}
