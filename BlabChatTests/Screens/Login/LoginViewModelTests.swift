//
//  LoginViewModelTests.swift
//  BlabChatTests
//
//  Created by Michael Pace on 6/6/26.
//

import Foundation
import Testing
@testable import BlabChat

@MainActor
@Suite("LoginViewModel")
struct LoginViewModelTests {

    @MainActor
    @Suite("login(using:)")
    struct Login {

        private func makeSubject() -> LoginViewModel {
            LoginViewModel()
        }

        @Test
        func `login - success - calls authService with correct credentials`() async throws {
            let mockAuthService = MockAuthService()
            let subject = makeSubject()
            subject.username = "pace"
            subject.password = "secret"

            try await subject.login(using: mockAuthService)

            #expect(mockAuthService.loginInvocations == 1)
            #expect(mockAuthService.lastLoginRequests.last?.username == "pace")
            #expect(mockAuthService.lastLoginRequests.last?.password == "secret")
        }

        @Test
        func `login - success - isLoading is false after`() async throws {
            let subject = makeSubject()

            try await subject.login(using: MockAuthService())

            #expect(!subject.isLoading)
        }

        @Test
        func `login - authService throws - rethrows`() async {
            let mockAuthService = MockAuthService()
            mockAuthService.loginError = NetworkError.badRequest
            let subject = makeSubject()

            await #expect(throws: NetworkError.badRequest) {
                try await subject.login(using: mockAuthService)
            }
        }

        @Test
        func `login - authService throws - isLoading is false after`() async {
            let mockAuthService = MockAuthService()
            mockAuthService.loginError = NetworkError.badRequest
            let subject = makeSubject()

            try? await subject.login(using: mockAuthService)

            #expect(!subject.isLoading)
        }
    }
}
