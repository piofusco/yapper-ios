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
                    ConversationPreviewsListView(
                        conversationPreviews: [
                            ConversationPreview(
                                id: "1",
                                author: "Bob Wills",
                                lastMessagePreview: "I am a ding dong daddy. I am a ding dong daddy. I am a ding dong daddy. I am a ding dong daddy. I am a ding dong daddy.",
                                timestamp: .zero
                            ),
                            ConversationPreview(
                                id: "2",
                                author: "Bob Wills",
                                lastMessagePreview: "I am a ding dong daddy. I am a ding dong daddy. I am a ding dong daddy. I am a ding dong daddy. I am a ding dong daddy.",
                                timestamp: .zero
                            ),
                            ConversationPreview(
                                id: "3",
                                author: "Bob Wills",
                                lastMessagePreview: "I am a ding dong daddy. I am a ding dong daddy. I am a ding dong daddy. I am a ding dong daddy. I am a ding dong daddy.",
                                timestamp: .zero
                            ),
                            ConversationPreview(
                                id: "4",
                                author: "Bob Wills",
                                lastMessagePreview: "I am a ding dong daddy. I am a ding dong daddy. I am a ding dong daddy. I am a ding dong daddy. I am a ding dong daddy.",
                                timestamp: .zero
                            ),
                            ConversationPreview(
                                id: "5",
                                author: "Bob Wills",
                                lastMessagePreview: "I am a ding dong daddy. I am a ding dong daddy. I am a ding dong daddy. I am a ding dong daddy. I am a ding dong daddy.",
                                timestamp: .zero
                            ),
                            ConversationPreview(
                                id: "6",
                                author: "Bob Wills",
                                lastMessagePreview: "I am a ding dong daddy. I am a ding dong daddy. I am a ding dong daddy. I am a ding dong daddy. I am a ding dong daddy.",
                                timestamp: .zero
                            ),
                            ConversationPreview(
                                id: "7",
                                author: "Bob Wills",
                                lastMessagePreview: "I am a ding dong daddy. I am a ding dong daddy. I am a ding dong daddy. I am a ding dong daddy. I am a ding dong daddy.",
                                timestamp: .zero
                            ),
                            ConversationPreview(
                                id: "3",
                                author: "Bob Wills",
                                lastMessagePreview: "I am a ding dong daddy. I am a ding dong daddy. I am a ding dong daddy. I am a ding dong daddy. I am a ding dong daddy.",
                                timestamp: .zero
                            )
                        ]
                    )
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
