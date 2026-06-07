//
//  MockLogger.swift
//  BlabChatTests
//
//  Created by Michael Pace on 6/7/26.
//

import Foundation
@testable import BlabChat

final class MockLogger: ScaffoldLogger {
    func debug(_ message: String) {}
    func error(_ message: String) {}
}
