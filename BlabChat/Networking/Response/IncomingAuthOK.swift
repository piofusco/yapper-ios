//
//  IncomingAuthOK.swift
//  BlabChat
//
//  Created by Michael Pace on 6/7/26.
//

import Foundation

struct IncomingAuthOK: Decodable {
    let user: String
    let friends: [IncomingFriend]
}
