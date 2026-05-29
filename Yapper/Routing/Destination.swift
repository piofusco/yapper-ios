//
//  Destination.swift
//  Secnds
//
//  Created by Michael Pace on 1/14/26.
//

import Foundation
import SwiftData

enum Destination: CustomStringConvertible, Hashable {
    case dismiss(_ dismiss: DismissType)
    case fullScreen(_ destination: FullScreenDestination)
    case push(_ destination: PushDestination)
    case tab(_ destination: TabDestination)

    public var description: String {
        switch self {
            case let .dismiss(dismiss): ".dismiss(\(dismiss))"
            case let .fullScreen(destination): ".fullScreen(\(destination))"
            case let .push(destination): ".push(\(destination))"
            case let .tab(destination): ".tab(\(destination))"
        }
    }
}

enum DismissType: String, Hashable {
    case popToRoot
}

enum FullScreenDestination: Hashable, CustomStringConvertible, Identifiable {
    case example

    public var description: String {
        switch self {
            case .example: "example"
        }
    }

    public var id: String {
        switch self {
            case .example: "example"
        }
    }
}

enum PushDestination: CustomStringConvertible, Hashable {
    case example

    public var description: String {
        switch self {
            case .example: "example"
        }
    }
}

enum TabDestination: String, Hashable {
    case example
}
