//
//  MockAuthService.swift
//  YapperTests
//
//  Created by Michael Pace on 6/6/26.
//

import Foundation
@testable import Yapper

@MainActor
final class MockAuthService: AuthService {
    var isAuthenticated = false

    var loginInvocations = 0
    var lastLoginRequests = [(username: String, password: String)]()
    var loginError: Error?
    func login(username: String, password: String) async throws {
        loginInvocations += 1
        lastLoginRequests.append((username: username, password: password))
        if let loginError { throw loginError }
        isAuthenticated = true
    }

    var createAccountInvocations = 0
    var lastCreateAccountRequests = [(username: String, password: String, code: String)]()
    var createAccountError: Error?
    func createAccount(username: String, password: String, code: String) async throws {
        createAccountInvocations += 1
        lastCreateAccountRequests.append((username: username, password: password, code: code))
        if let createAccountError { throw createAccountError }
        isAuthenticated = true
    }

    var logoutInvocations = 0
    func logout() {
        logoutInvocations += 1
        isAuthenticated = false
    }
}
