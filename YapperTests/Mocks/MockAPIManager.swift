//
//  MockAPIManager.swift
//  YapperTests
//
//  Created by Michael Pace on 6/6/26.
//

import Foundation
@testable import Yapper

final class MockAPIManager: APIManager, @unchecked Sendable {
    var loginInvocations = 0
    var lastLoginRequests = [AuthRequest]()
    var nextLoginToken = "mock-token"
    var loginError: Error?

    func login(with request: AuthRequest) async throws -> String {
        loginInvocations += 1
        lastLoginRequests.append(request)
        if let loginError { throw loginError }
        return nextLoginToken
    }
}
