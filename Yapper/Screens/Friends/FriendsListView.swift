//
//  FriendsListView.swift
//  Yapper
//
//  Created by Michael Pace on 6/7/26.
//

import SwiftUI

struct FriendsListView: View {
    @Environment(DefaultChatService.self) private var chatService
    @Environment(Router.self) private var router

    var body: some View {
        List(chatService.friends) { friend in
            FriendListCell(friend: friend)
                .contentShape(Rectangle())
                .onTapGesture {
                    router.route(to: .push(.conversation(id: friend.username)))
                }
        }
        .listStyle(.plain)
        .navigationTitle("Friends")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        FriendsListView()
    }
    .environment(DefaultChatService())
    .environment(Router(level: 0, identifierTab: .conversations))
}
