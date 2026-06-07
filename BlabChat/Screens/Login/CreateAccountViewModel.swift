//
//  CreateAccountViewModel.swift
//  BlabChat
//
//  Created by Michael Pace on 6/6/26.
//

import Foundation
import Observation

@Observable
@MainActor
final class CreateAccountViewModel {
    var username = ""
    var password = ""
    var code = ""
    var isLoading = false

    func createAccount(using authService: any AuthService) async throws {
        isLoading = true
        defer { isLoading = false }

        try await authService.createAccount(
            username: username,
            password: password,
            code: code
        )
    }
}
