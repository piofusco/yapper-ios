//
//  Friend.swift
//  Burrw
//
//  Created by Michael Pace on 6/6/26.
//

import Foundation

struct Friend: Identifiable, Equatable {
    var id: String { username }
    let username: String
    let online: Bool
}
