//
//  YapperURL.swift
//  Yapper
//
//  Created by Michael Pace on 6/6/26.
//

import Foundation

enum YapperEndpoint {
    case login
    case webSocket

    var url: URL {
        var components = URLComponents()
        components.host = "network.devan.chat"
        switch self {
        case .login:
            components.scheme = "https"
            components.path = "/login"
        case .webSocket:
            components.scheme = "ws"
            components.port = 8222
            components.path = "/ws"
        }
        return components.url!
    }
}
