//
//  MessagePreviewListViewCell.swift
//  BlabChat
//
//  Created by Michael Pace on 6/4/26.
//

import SwiftUI

struct ConversationPreview: Identifiable {
    let id: String
    let author: String
    let lastMessagePreview: String
    let timestamp: Duration
}

struct ConversationPreviewListCell: View {
    private let conversationPreview: ConversationPreview
    private let isLast: Bool
    private let isHighlighted: Bool
    private let didTap: () -> Void

    init(
        conversationPreview: ConversationPreview,
        isLast: Bool = false,
        isHighlighted: Bool = false,
        didTap: @escaping () -> Void,

    ) {
        self.conversationPreview = conversationPreview
        self.isLast = isLast
        self.isHighlighted = isHighlighted
        self.didTap = didTap
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                profileImage
                    .padding(.trailing, 10)

                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        Text(conversationPreview.author)
                            .fontWeight(.bold)
                        Spacer()
                        Text(conversationPreview.timestamp, format: .time(pattern: .hourMinute))
                    }
                    .padding(.bottom, 2)
                    Text(conversationPreview.lastMessagePreview)
                        .lineLimit(3)
                        .padding(.bottom, 15)
                    if !isLast {
                        Divider()
                            .background(.black)
                            .padding(0)
                    }
                }
                .foregroundStyle(.black)
                .background(.white)
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            .overlay {
                if isHighlighted {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(Color.blue.opacity(0.1))
                }
            }
        }
        .onTapGesture {
            didTap()
        }
    }

    private var profileImage: some View {
        Image(systemName: "person.fill")
            .resizable()
            .frame(width: 25, height: 25)
            .padding(5)
            .background(.gray)
            .foregroundColor(.white)
            .clipShape(Circle())
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
                    id: "3",
                    author: "Bob Wills",
                    lastMessagePreview: "I am a ding dong daddy. I am a ding dong daddy. I am a ding dong daddy. I am a ding dong daddy. I am a ding dong daddy.",
                    timestamp: .zero
                )
            ]
        )
    }
    .environment(Router(level: 0, identifierTab: nil))
}
