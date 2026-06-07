//
//  RootContainerView.swift
//  Secnds
//
//  Created by Michael Pace on 5/17/26.
//

import SwiftUI

struct RootContainerView: View {
    @Environment(\.modelContext) var modelContext

    @State var router: Router = Router(level: 0, identifierTab: nil)
    @State private var alertService = AlertService()
    @State private var authService = DefaultAuthService()
    @State private var chatService = DefaultChatService()

    var body: some View {
        Group {
            if authService.isAuthenticated {
                TabView {
                    NavigationContainer(parentRouter: router, tab: .conversations) {
                        FriendsListView()
                    }
                    .tabItem { Label("Friends", systemImage: "person.2") }

                    NavigationContainer(parentRouter: router, tab: .settings) {
                        SettingsView()
                    }
                    .tabItem { Label("Settings", systemImage: "gearshape") }
                }
            } else {
                NavigationContainer(parentRouter: router) {
                    RootView()
                }
            }
        }
        .environment(authService)
        .environment(chatService)
        .environment(alertService)
        .task(id: authService.isAuthenticated) {
            if authService.isAuthenticated, let token = authService.token {
                try? await chatService.connect(token: token)
            } else {
                await chatService.disconnect()
            }
        }
        .overlay {
            if let content = alertService.current {
                AlertView(content: content) { alertService.dismiss() }
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.15), value: alertService.current != nil)
    }
}
