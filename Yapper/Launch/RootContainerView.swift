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

    var body: some View {
        Group {
            if authService.isAuthenticated {
                TabView {
                    NavigationContainer(parentRouter: router, tab: .conversations) {
                        ConversationPreviewsListView()
                    }
                    .tabItem { Label("Messages", systemImage: "message") }
                }
            } else {
                NavigationContainer(parentRouter: router) {
                    RootView()
                }
            }
        }
        .environment(authService)
        .environment(alertService)
        .overlay {
            if let content = alertService.current {
                AlertView(content: content) { alertService.dismiss() }
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.15), value: alertService.current != nil)
    }
}
