//
//  ConversationPreviewsListView.swift
//  Burrw
//
//  Created by Michael Pace on 5/31/26.
//

import Foundation
import SwiftUI

struct ConversationPreviewsListView: View {
    @Environment(Router.self) private var router

    @State private var selectedId: String = ""

    private let conversationPreviews: [ConversationPreview]

    init(
        conversationPreviews: [ConversationPreview] = [
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
                id: "8",
                author: "Bob Wills",
                lastMessagePreview: "I am a ding dong daddy. I am a ding dong daddy. I am a ding dong daddy. I am a ding dong daddy. I am a ding dong daddy.",
                timestamp: .zero
            )
        ]
    ) {
        self.conversationPreviews = conversationPreviews
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(conversationPreviews) { preview in
                    ConversationPreviewListCell(
                        conversationPreview: preview,
                        isLast: false,
                        isHighlighted: selectedId == preview.id,
                        didTap: {
                            selectedId = preview.id
                            router.route(to: .push(.conversation(id: preview.id)))
                        }
                    )
                }
            }
        }
        .navigationTitle("Chat Title")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    
                } label: {
                    Image(Icon.edit.rawValue)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
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
                    id: "8",
                    author: "Bob Wills",
                    lastMessagePreview: "I am a ding dong daddy. I am a ding dong daddy. I am a ding dong daddy. I am a ding dong daddy. I am a ding dong daddy.",
                    timestamp: .zero
                )
            ]
        )
    }
    .environment(Router(level: 0, identifierTab: nil))
}
