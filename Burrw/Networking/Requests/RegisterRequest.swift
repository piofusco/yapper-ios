//
//  RegisterRequest.swift
//  Burrw
//
//  Created by Michael Pace on 6/6/26.
//

import Foundation

struct RegisterRequest: Encodable {
    let username: String
    let password: String
    let code: String
}
