//
//  CreateAccountViewModelTests.swift
//  YapperTests
//
//  Created by Michael Pace on 6/6/26.
//

import Foundation
import Testing
@testable import Yapper

@MainActor
@Suite("CreateAccountViewModel")
struct CreateAccountViewModelTests {

    @MainActor
    @Suite("createAccount(using:)")
    struct CreateAccount {

        private func makeSubject() -> CreateAccountViewModel {
            CreateAccountViewModel()
        }

        @Test
        func `createAccount - success - calls authService with correct credentials`() async throws {
            let mockAuthService = MockAuthService()
            let subject = makeSubject()
            subject.username = "pace"
            subject.password = "secret"
            subject.code = "supersecret"

            try await subject.createAccount(using: mockAuthService)

            #expect(mockAuthService.createAccountInvocations == 1)
            #expect(mockAuthService.lastCreateAccountRequests.last?.username == "pace")
            #expect(mockAuthService.lastCreateAccountRequests.last?.password == "secret")
            #expect(mockAuthService.lastCreateAccountRequests.last?.code == "supersecret")
        }

        @Test
        func `createAccount - success - isLoading is false after`() async throws {
            let subject = makeSubject()

            try await subject.createAccount(using: MockAuthService())

            #expect(!subject.isLoading)
        }

        @Test
        func `createAccount - authService throws - rethrows`() async {
            let mockAuthService = MockAuthService()
            mockAuthService.createAccountError = NetworkError.badRequest
            let subject = makeSubject()

            await #expect(throws: NetworkError.badRequest) {
                try await subject.createAccount(using: mockAuthService)
            }
        }

        @Test
        func `createAccount - authService throws - isLoading is false after`() async {
            let mockAuthService = MockAuthService()
            mockAuthService.createAccountError = NetworkError.badRequest
            let subject = makeSubject()

            try? await subject.createAccount(using: mockAuthService)

            #expect(!subject.isLoading)
        }
    }
}
