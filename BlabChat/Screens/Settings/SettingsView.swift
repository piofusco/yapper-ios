//
//  SettingsView.swift
//  BlabChat
//
//  Created by Michael Pace on 6/6/26.
//

import SwiftUI

struct SettingsView: View {
    @Environment(DefaultAuthService.self) private var authService

    var body: some View {
        List {
            Button(role: .destructive) {
                authService.logout()
            } label: {
                Text("Log Out")
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
    .environment(DefaultAuthService())
}
