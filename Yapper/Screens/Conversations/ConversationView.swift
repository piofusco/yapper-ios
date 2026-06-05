//
//  ConversationView.swift
//  Yapper
//
//  Created by Michael Pace on 6/4/26.
//

import SwiftUI

struct Conversation {
    let id: String
    let title: String
}

struct ConversationView: View {
    @Environment(\.dismiss) var dismiss
    @State private var text: String = ""

    private let id: String

    init(
        id: String,
        text: String = ""
    ) {
        self.id = id
        _text = State(initialValue: text)
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                MessageView(message: Message(author: "Miller", text: "Sup", date: .now))
                MessageView(message: Message(author: "Miller", text: "Sup", date: .now))
                MessageView(
                    message: Message(
                        author: "Miller",
                        text: "Sup",
                        date: .now
                    ),
                    isSelf: true
                )
                MessageView(message: Message(author: "Miller", text: "Sup", date: .now))
                MessageView(message: Message(author: "Miller", text: "Sup", date: .now))
                MessageView(
                    message: Message(
                        author: "Miller",
                        text: "Sup",
                        date: .now
                    ),
                    isSelf: true
                )
                MessageView(message: Message(author: "Miller", text: "Sup", date: .now))
                MessageView(message: Message(author: "Miller", text: "Sup", date: .now))
                MessageView(
                    message: Message(
                        author: "Miller",
                        text: "Sup",
                        date: .now
                    ),
                    isSelf: true
                )
                MessageView(message: Message(author: "Miller", text: "Sup", date: .now))
                MessageView(message: Message(author: "Miller", text: "Sup", date: .now))
                MessageView(
                    message: Message(
                        author: "Miller",
                        text: "Sup",
                        date: .now
                    ),
                    isSelf: true
                )
                MessageView(message: Message(author: "Miller", text: "Sup", date: .now))
                MessageView(message: Message(author: "Miller", text: "Sup", date: .now))
                MessageView(
                    message: Message(
                        author: "Miller",
                        text: "Sup",
                        date: .now
                    ),
                    isSelf: true
                )
                MessageView(message: Message(author: "Miller", text: "Sup", date: .now))
                MessageView(message: Message(author: "Miller", text: "Sup", date: .now))
                MessageView(
                    message: Message(
                        author: "Miller",
                        text: "Sup",
                        date: .now
                    ),
                    isSelf: true
                )
                MessageView(message: Message(author: "Miller", text: "Sup", date: .now))
                MessageView(message: Message(author: "Miller", text: "Sup", date: .now))
                MessageView(
                    message: Message(
                        author: "Miller",
                        text: "Sup",
                        date: .now
                    ),
                    isSelf: true
                )
                MessageView(message: Message(author: "Miller", text: "Sup", date: .now))
                MessageView(message: Message(author: "Miller", text: "Sup", date: .now))
                MessageView(
                    message: Message(
                        author: "Miller",
                        text: "Sup",
                        date: .now
                    ),
                    isSelf: true
                )
                MessageView(message: Message(author: "Miller", text: "Sup", date: .now))
                MessageView(message: Message(author: "Miller", text: "Sup", date: .now))
                MessageView(
                    message: Message(
                        author: "Miller",
                        text: "Sup",
                        date: .now
                    ),
                    isSelf: true
                )
            }
            .padding(.top, 10)
        }
        .scrollDismissesKeyboard(.interactively)
        .safeAreaInset(edge: .bottom) {
            GrowingTextInput(text: $text) {
                print("Hello")
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Title")
            }
        }
        .toolbar(.hidden, for: .tabBar)
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
        ConversationView(
            id: "1",
            text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
        )
    }
}
