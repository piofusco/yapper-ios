//
//  MockAPIManager.swift
//  BurrwTests
//
//  Created by Michael Pace on 6/6/26.
//

import Foundation
@testable import Burrw

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

    var registerInvocations = 0
    var lastRegisterRequests = [RegisterRequest]()
    var nextRegisterToken = "mock-token"
    var registerError: Error?

    func register(with request: RegisterRequest) async throws -> String {
        registerInvocations += 1
        lastRegisterRequests.append(request)
        if let registerError { throw registerError }
        return nextRegisterToken
    }
}
