//
//  AuthService.swift
//  BlabChat
//
//  Created by Michael Pace on 6/6/26.
//

import Foundation
import Observation

@MainActor
protocol AuthService: AnyObject {
    var isAuthenticated: Bool { get }

    func login(
        username: String,
        password: String
    ) async throws
    func createAccount(
        username: String,
        password: String,
        code: String
    ) async throws
    func logout()
}

@Observable
@MainActor
final class DefaultAuthService: AuthService {
    private(set) var token: String?

    var isAuthenticated: Bool { token != nil }

    private let tokenStore: any TokenStore
    private let apiManager: any APIManager

    init(
        tokenStore: any TokenStore = KeychainTokenStore(),
        apiManager: any APIManager = DefaultAPIManager()
    ) {
        self.tokenStore = tokenStore
        self.apiManager = apiManager
        self.token = try? tokenStore.load()
    }

    func login(
        username: String,
        password: String
    ) async throws {
        let token = try await apiManager.login(with: AuthRequest(username: username, password: password))
        self.token = token
        try tokenStore.save(token)
    }

    func createAccount(
        username: String,
        password: String,
        code: String
    ) async throws {
        let token = try await apiManager.register(
            with: RegisterRequest(
                username: username,
                password: password,
                code: code
            )
        )
        self.token = token
        try tokenStore.save(token)
    }

    func logout() {
        try? tokenStore.delete()
        token = nil
    }
}
