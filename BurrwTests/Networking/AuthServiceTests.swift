//
//  AuthServiceTests.swift
//  BurrwTests
//
//  Created by Michael Pace on 6/6/26.
//

import Foundation
import Testing
@testable import Burrw

@MainActor
@Suite("DefaultAuthService")
struct AuthServiceTests {

    private func makeSubject(
        tokenStore: MockTokenStore = MockTokenStore(),
        apiManager: MockAPIManager = MockAPIManager()
    ) -> DefaultAuthService {
        DefaultAuthService(tokenStore: tokenStore, apiManager: apiManager)
    }

    @Test
    func `init - token in store - isAuthenticated is true`() {
        let mockTokenStore = MockTokenStore()
        mockTokenStore.nextToken = "some-token"

        let subject = makeSubject(tokenStore: mockTokenStore)

        #expect(subject.isAuthenticated)
    }

    @Test
    func `init - no token in store - isAuthenticated is false`() {
        let subject = makeSubject()

        #expect(!subject.isAuthenticated)
    }

    @Test
    func `login - success - isAuthenticated becomes true`() async throws {
        let subject = makeSubject()

        try await subject.login(username: "pace", password: "secret")

        #expect(subject.isAuthenticated)
    }

    @Test
    func `login - success - saves token to store`() async throws {
        let mockTokenStore = MockTokenStore()
        let mockAPIManager = MockAPIManager()
        mockAPIManager.nextLoginToken = "my-token"
        let subject = makeSubject(tokenStore: mockTokenStore, apiManager: mockAPIManager)

        try await subject.login(username: "pace", password: "secret")

        #expect(mockTokenStore.saveInvocations == 1)
        #expect(mockTokenStore.lastSavedTokens.last == "my-token")
    }

    @Test
    func `login - success - calls apiManager with correct credentials`() async throws {
        let mockAPIManager = MockAPIManager()
        let subject = makeSubject(apiManager: mockAPIManager)

        try await subject.login(username: "pace", password: "secret")

        #expect(mockAPIManager.loginInvocations == 1)
        #expect(mockAPIManager.lastLoginRequests.last?.username == "pace")
        #expect(mockAPIManager.lastLoginRequests.last?.password == "secret")
    }

    @Test
    func `login - apiManager throws - isAuthenticated remains false`() async {
        let mockAPIManager = MockAPIManager()
        mockAPIManager.loginError = NetworkError.badRequest
        let subject = makeSubject(apiManager: mockAPIManager)

        try? await subject.login(username: "pace", password: "wrong")

        #expect(!subject.isAuthenticated)
    }

    @Test
    func `login - apiManager throws - does not save token`() async {
        let mockTokenStore = MockTokenStore()
        let mockAPIManager = MockAPIManager()
        mockAPIManager.loginError = NetworkError.badRequest
        let subject = makeSubject(tokenStore: mockTokenStore, apiManager: mockAPIManager)

        try? await subject.login(username: "pace", password: "wrong")

        #expect(mockTokenStore.saveInvocations == 0)
    }

    @Test
    func `login - tokenStore throws - rethrows error`() async {
        let mockTokenStore = MockTokenStore()
        mockTokenStore.saveError = KeychainError.saveFailed(errSecDuplicateItem)
        let subject = makeSubject(tokenStore: mockTokenStore)

        await #expect(throws: KeychainError.saveFailed(errSecDuplicateItem)) {
            try await subject.login(username: "pace", password: "secret")
        }
    }

    @Test
    func `logout - isAuthenticated becomes false`() async throws {
        let subject = makeSubject()
        try await subject.login(username: "pace", password: "secret")

        subject.logout()

        #expect(!subject.isAuthenticated)
    }

    @Test
    func `logout - deletes token from store`() async throws {
        let mockTokenStore = MockTokenStore()
        let subject = makeSubject(tokenStore: mockTokenStore)
        try await subject.login(username: "pace", password: "secret")

        subject.logout()

        #expect(mockTokenStore.deleteInvocations == 1)
    }
}
