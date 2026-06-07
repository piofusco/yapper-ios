//
//  BurrwURL.swift
//  Burrw
//
//  Created by Michael Pace on 6/6/26.
//

import Foundation

enum BurrwEndpoint {
    case login
    case register
    case webSocket

    var url: URL {
        var components = URLComponents()
        components.host = "chat.devan.network"
        switch self {
        case .login:
            components.scheme = "https"
            components.path = "/login"
        case .register:
            components.scheme = "https"
            components.path = "/register"
        case .webSocket:
            components.scheme = "wss"
            components.path = "/ws"
        }
        return components.url!
    }
}
