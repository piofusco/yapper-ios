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
        func `createAccount - success - calls authService with correct credentials`() async {
            let mockAuthService = MockAuthService()
            let subject = makeSubject()
            subject.username = "pace"
            subject.password = "secret"

            await subject.createAccount(using: mockAuthService)

            #expect(mockAuthService.createAccountInvocations == 1)
            #expect(mockAuthService.lastCreateAccountRequests.last?.username == "pace")
            #expect(mockAuthService.lastCreateAccountRequests.last?.password == "secret")
        }

        @Test
        func `createAccount - success - isLoading is false after`() async {
            let mockAuthService = MockAuthService()
            let subject = makeSubject()

            await subject.createAccount(using: mockAuthService)

            #expect(!subject.isLoading)
        }

        @Test
        func `createAccount - success - errorMessage is nil`() async {
            let mockAuthService = MockAuthService()
            let subject = makeSubject()

            await subject.createAccount(using: mockAuthService)

            #expect(subject.errorMessage == nil)
        }

        @Test
        func `createAccount - authService throws - sets errorMessage`() async {
            let mockAuthService = MockAuthService()
            mockAuthService.createAccountError = NetworkError.badRequest
            let subject = makeSubject()

            await subject.createAccount(using: mockAuthService)

            #expect(subject.errorMessage != nil)
        }

        @Test
        func `createAccount - authService throws - isLoading is false after`() async {
            let mockAuthService = MockAuthService()
            mockAuthService.createAccountError = NetworkError.badRequest
            let subject = makeSubject()

            await subject.createAccount(using: mockAuthService)

            #expect(!subject.isLoading)
        }

        @Test
        func `createAccount - error then success - clears errorMessage`() async {
            let mockAuthService = MockAuthService()
            mockAuthService.createAccountError = NetworkError.badRequest
            let subject = makeSubject()
            await subject.createAccount(using: mockAuthService)
            #expect(subject.errorMessage != nil)

            mockAuthService.createAccountError = nil
            await subject.createAccount(using: mockAuthService)

            #expect(subject.errorMessage == nil)
        }
    }
}
