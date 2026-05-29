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

    var body: some View {
        TabView(selection: $router.selectedTab) {
            Tab(value: TabDestination.example) {
                NavigationContainer(parentRouter: router, tab: .example) {
                    EmptyView()
                }
            } label: {
                Label {
                    Text("Example")
                } icon: {
                    Image(Icon.timer.rawValue)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .clipped()
                }
            }
        }
        .tint(.primary)
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
