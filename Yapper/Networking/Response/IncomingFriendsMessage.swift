//
//  IncomingFriendsMessage.swift
//  Yapper
//
//  Created by Michael Pace on 6/6/26.
//

import Foundation

struct IncomingFriendsMessage: Decodable {
    let friends: [IncomingFriend]
}

struct IncomingFriend: Decodable {
    let username: String
    let online: Bool
}
