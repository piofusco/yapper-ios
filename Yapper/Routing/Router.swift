//
//  Router.swift
//  Secnds
//
//  Created by Michael Pace on 1/14/26.
//
import OSLog
import SwiftUI

@Observable
final class Router {
    private let id = UUID()
    private let logger = Logger(
        subsystem: "come.americo.Yaper",
        category: "Navigation"
    )

    var isActive = false
    var navigationStackPath: [PushDestination] = []
    weak var parent: Router?

    var selectedTab: TabDestination?
    var presentingFullScreen: FullScreenDestination?

    let level: Int
    let identifierTab: TabDestination?

    init(
        level: Int,
        identifierTab: TabDestination?,
        navigationStackPath: [PushDestination] = []
    ) {
        self.level = level
        self.identifierTab = identifierTab
        self.navigationStackPath = navigationStackPath
    }

    func childRouter(for tab: TabDestination? = nil) -> Router {
        let router = Router(level: level + 1, identifierTab: tab ?? identifierTab)
        router.parent = self
        return router
    }

    func route(to destination: Destination) {
        switch destination {
            case .dismiss:
                navigationStackPath.removeAll()
                resignActive()
            case .fullScreen(let destination): presentingFullScreen = destination
            case .push(let destination): navigationStackPath.append(destination)
            case .tab(let tab):
                if level == 0 {
                    selectedTab = tab
                } else {
                    parent?.route(to: destination)
                    navigationStackPath = []
                    presentingFullScreen = nil
                }
        }
    }

    func resignActive() {
        isActive = false
        parent?.setActive()
    }

    func setActive() {
        parent?.resignActive()
        isActive = true
    }

    static func previewRouter() -> Router {
        Router(level: 0, identifierTab: nil)
    }
}

extension Router: CustomDebugStringConvertible {
    public var debugDescription: String {
        "Router[\(shortId) - \(identifierTabName) - Level: \(level)]"
    }

    private var shortId: String { String(id.uuidString.split(separator: "-").first ?? "") }

    private var identifierTabName: String {
        identifierTab?.rawValue ?? "No Tab"
    }
}
