//
//  FriendListCell.swift
//  BlabChat
//
//  Created by Michael Pace on 6/7/26.
//

import SwiftUI

struct FriendListCell: View {
    let friend: Friend

    var body: some View {
        HStack {
            Text(friend.username)
            Spacer()
            Circle()
                .fill(friend.online ? Color.green : Color.gray.opacity(0.4))
                .frame(width: 10, height: 10)
        }
    }
}
