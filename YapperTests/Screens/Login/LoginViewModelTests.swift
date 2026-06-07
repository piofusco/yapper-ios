//
//  LoginViewModelTests.swift
//  YapperTests
//
//  Created by Michael Pace on 6/6/26.
//

import Foundation
import Testing
@testable import Yapper

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
        func `login - success - calls authService with correct credentials`() async {
            let mockAuthService = MockAuthService()
            let subject = makeSubject()
            subject.username = "pace"
            subject.password = "secret"

            await subject.login(using: mockAuthService)

            #expect(mockAuthService.loginInvocations == 1)
            #expect(mockAuthService.lastLoginRequests.last?.username == "pace")
            #expect(mockAuthService.lastLoginRequests.last?.password == "secret")
        }

        @Test
        func `login - success - isLoading is false after`() async {
            let mockAuthService = MockAuthService()
            let subject = makeSubject()

            await subject.login(using: mockAuthService)

            #expect(!subject.isLoading)
        }

        @Test
        func `login - success - errorMessage is nil`() async {
            let mockAuthService = MockAuthService()
            let subject = makeSubject()

            await subject.login(using: mockAuthService)

            #expect(subject.errorMessage == nil)
        }

        @Test
        func `login - authService throws - sets errorMessage`() async {
            let mockAuthService = MockAuthService()
            mockAuthService.loginError = NetworkError.badRequest
            let subject = makeSubject()

            await subject.login(using: mockAuthService)

            #expect(subject.errorMessage != nil)
        }

        @Test
        func `login - authService throws - isLoading is false after`() async {
            let mockAuthService = MockAuthService()
            mockAuthService.loginError = NetworkError.badRequest
            let subject = makeSubject()

            await subject.login(using: mockAuthService)

            #expect(!subject.isLoading)
        }

        @Test
        func `login - error then success - clears errorMessage`() async {
            let mockAuthService = MockAuthService()
            mockAuthService.loginError = NetworkError.badRequest
            let subject = makeSubject()
            await subject.login(using: mockAuthService)
            #expect(subject.errorMessage != nil)

            mockAuthService.loginError = nil
            await subject.login(using: mockAuthService)

            #expect(subject.errorMessage == nil)
        }
    }
}
