//
//  OutgoingAuth.swift
//  Burrw
//
//  Created by Michael Pace on 6/7/26.
//

import Foundation

struct OutgoingAuth: Encodable {
    let type = "auth"
    let token: String
}
