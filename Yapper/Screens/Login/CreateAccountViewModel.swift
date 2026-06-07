//
//  CreateAccountViewModel.swift
//  Yapper
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
    var isLoading = false
    var errorMessage: String?

    func createAccount(using authService: any AuthService) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            try await authService.createAccount(username: username, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
