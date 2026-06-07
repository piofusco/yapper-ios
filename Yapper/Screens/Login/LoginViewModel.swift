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
    var errorMessage: String?

    func login(using authService: any AuthService) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            try await authService.login(username: username, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
