//
//  SettingsView.swift
//  BlabChat
//
//  Created by Michael Pace on 6/6/26.
//

import SwiftUI

struct SettingsView: View {
    @Environment(DefaultAuthService.self) private var authService
    @Environment(DefaultChatService.self) private var chatService

    var body: some View {
        Group {
            if !chatService.isConnected {
                ContentUnavailableView {
                    Label("Uh Oh", systemImage: "wifi.exclamationmark")
                } description: {
                    Text("Something went wrong. Please try again.")
                } actions: {
                    Button {
                        guard let token = authService.token else { return }
                        Task { try? await chatService.connect(token: token) }
                    } label: {
                        Text("Reconnect")
                            .font(.system(size: 17, weight: .semibold))
                            .padding(16)
                            .foregroundStyle(.white)
                            .background(AppColor.orange.color)
                            .clipShape(.capsule)
                            .contentShape(.capsule)
                    }
                }
            } else {
                Form {
                    if let user = chatService.currentUser {
                        Section {
                            LabeledContent("Logged in as", value: user)
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Text("Settings")
                    Circle()
                        .fill(chatService.isConnected ? Color.green : Color.red)
                        .frame(width: 10, height: 10)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    authService.logout()
                } label: {
                    Text("Logout")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
    .environment(DefaultAuthService())
    .environment(DefaultChatService())
}
