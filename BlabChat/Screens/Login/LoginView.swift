//
//  LoginView.swift
//  BlabChat
//
//  Created by Michael Pace on 6/6/26.
//

import SwiftUI

struct LoginView: View {
    @Environment(DefaultAuthService.self) private var authService
    @Environment(AlertService.self) private var alertService
    @State private var viewModel = LoginViewModel()

    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            TextField("Username", text: $viewModel.username)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(.roundedBorder)
            Spacer()
            Button {
                Task {
                    do {
                        try await viewModel.login(using: authService)
                    } catch {
                        alertService.show(title: "Login Failed", message: error.localizedDescription)
                    }
                }
            } label: {
                Group {
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Login")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(AppColor.orange.color)
                .clipShape(.capsule)
                .contentShape(.capsule)
            }
            .disabled(viewModel.isLoading)
        }
        .padding(.horizontal)
        .padding(.bottom, 32)
        .navigationTitle("Login")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        LoginView()
    }
    .environment(Router.previewRouter())
    .environment(DefaultAuthService())
    .environment(AlertService())
}
