//
//  LoginViewModel.swift
//  Yapper
//
//  Created by Michael Pace on 6/6/26.
//

import Foundation
import Observation

@Observable
@MainActor
final class LoginViewModel {
    var username = ""
    var password = ""
    var isLoading = false

    func login(using authService: any AuthService) async throws {
        isLoading = true
        defer { isLoading = false }
        try await authService.login(username: username, password: password)
    }
}
