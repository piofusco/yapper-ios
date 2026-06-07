//
//  ScaffoldLogger.swift
//  BlabChat
//
//  Created by Michael Pace on 6/7/26.
//

import Foundation
import OSLog

protocol ScaffoldLogger {
    func debug(_ message: String)
    func error(_ message: String)
}

struct DefaultLogger: ScaffoldLogger {
    private let logger: Logger

    init(
        subsystem: String = Bundle.main.bundleIdentifier ?? "BlabChat",
        category: String
    ) {
        self.logger = Logger(subsystem: subsystem, category: category)
    }

    func debug(_ message: String) {
        logger.debug("\(message)")
    }

    func error(_ message: String) {
        logger.error("\(message)")
    }
}
