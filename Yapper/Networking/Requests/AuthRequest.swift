//
//  AuthRequest.swift
//  Yapper
//
//  Created by Michael Pace on 6/6/26.
//

import Foundation

struct AuthRequest: Encodable {
    let username: String
    let password: String
}
