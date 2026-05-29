//
//  AlertService.swift
//  Secnds
//
//  Created by Michael Pace on 5/27/26.
//

import SwiftUI

struct AlertAction: Identifiable {
    let id = UUID()
    let title: String
    let role: ButtonRole?
    let handler: (() -> Void)?

    static func ok(handler: (() -> Void)? = nil) -> AlertAction {
        AlertAction(title: "OK", role: nil, handler: handler)
    }

    static func cancel(handler: (() -> Void)? = nil) -> AlertAction {
        AlertAction(title: "Cancel", role: .cancel, handler: handler)
    }

    static func destructive(_ title: String, handler: (() -> Void)? = nil) -> AlertAction {
        AlertAction(title: title, role: .destructive, handler: handler)
    }
}

struct AlertContent {
    let title: String
    let message: String?
    let actions: [AlertAction]
}

@Observable
@MainActor
final class AlertService {
    var current: AlertContent?

    func show(
        title: String,
        message: String? = nil,
        actions: [AlertAction] = [.ok()]
    ) {
        current = AlertContent(
            title: title,
            message: message,
            actions: actions
        )
    }

    func dismiss() {
        current = nil
    }
}
