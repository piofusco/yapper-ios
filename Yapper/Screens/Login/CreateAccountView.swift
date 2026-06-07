//
//  CreateAccountView.swift
//  Yapper
//
//  Created by Michael Pace on 6/6/26.
//

import SwiftUI

struct CreateAccountView: View {
    @Environment(DefaultAuthService.self) private var authService
    @State private var viewModel = CreateAccountViewModel()

    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            TextField("Username", text: $viewModel.username)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(.roundedBorder)
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .font(.footnote)
            }
            Spacer()
            Button {
                Task { await viewModel.createAccount(using: authService) }
            } label: {
                Group {
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Create Account")
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
        .navigationTitle("Create Account")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        CreateAccountView()
    }
    .environment(Router.previewRouter())
    .environment(DefaultAuthService())
}
