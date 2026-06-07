//
//  FriendsListView.swift
//  BlabChat
//
//  Created by Michael Pace on 6/7/26.
//

import SwiftUI

struct FriendsListView: View {
    @Environment(DefaultChatService.self) private var chatService
    @Environment(DefaultAuthService.self) private var authService
    @Environment(Router.self) private var router

    var body: some View {
        Group {
            if !chatService.isConnected {
                ContentUnavailableView {
                    Label("Uh Oh", systemImage: "wifi.exclamationmark")
                } description: {
                    Text("Something went wrong. Please try again.")
                } actions: {
                    Button {
                        guard let token = authService.token else { return }
                        Task { try? await chatService.connect(token: token) }
                    } label: {
                        Text("Reconnect")
                            .font(.system(size: 17, weight: .semibold))
                            .padding(16)
                            .foregroundStyle(.white)
                            .background(AppColor.orange.color)
                            .clipShape(.capsule)
                            .contentShape(.capsule)
                    }
                }
            } else {
                List(chatService.friends) { friend in
                    FriendListCell(friend: friend)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            router.route(to: .push(.conversation(id: friend.username)))
                        }
                }
                .listStyle(.plain)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Text("Friends")
                    Circle()
                        .fill(chatService.isConnected ? Color.green : Color.red)
                        .frame(width: 10, height: 10)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    guard let token = authService.token else { return }
                    Task { try? await chatService.refresh(token: token) }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        FriendsListView()
    }
    .environment(DefaultChatService())
    .environment(DefaultAuthService())
    .environment(Router(level: 0, identifierTab: .conversations))
}
