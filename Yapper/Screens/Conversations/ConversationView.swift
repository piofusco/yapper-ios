//
//  ConversationView.swift
//  Yapper
//
//  Created by Michael Pace on 6/4/26.
//

import SwiftUI

struct ConversationView: View {
    @Environment(DefaultChatService.self) private var chatService
    @Environment(AlertService.self) private var alertService
    @State private var viewModel = ConversationViewModel()

    private let recipient: String

    init(recipient: String) {
        self.recipient = recipient
    }

    private var messages: [ChatMessage] {
        chatService.messages.filter { $0.partner == recipient }
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(messages) { chatMessage in
                        MessageView(
                            message: Message(
                                author: chatMessage.partner,
                                text: chatMessage.text,
                                date: chatMessage.timestamp
                            ),
                            isSelf: chatMessage.isSent
                        )
                        .id(chatMessage.id)
                    }
                }
                .padding(.top, 10)
            }
            .scrollDismissesKeyboard(.interactively)
            .onChange(of: messages.count) {
                if let last = messages.last {
                    withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            GrowingTextInput(text: $viewModel.inputText) {
                Task {
                    do {
                        try await viewModel.send(to: recipient, using: chatService)
                    } catch {
                        alertService.show(title: "Failed to send", message: error.localizedDescription)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(recipient)
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    NavigationStack {
        ConversationView(recipient: "pace")
    }
    .environment(DefaultChatService())
    .environment(AlertService())
}
