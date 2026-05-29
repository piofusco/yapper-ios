//
//  NavigationButton.swift
//  Secnds
//
//  Created by Michael Pace on 1/14/26.
//
import Foundation
import SwiftUI

struct NavigationButton<Content: View>: View {
    @Environment(Router.self) private var router

    private let destination: Destination
    private let action: (() -> Void)?
    @ViewBuilder private var content: () -> Content

    init(
        destination: Destination,
        action: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.destination = destination
        self.action = action
        self.content = content
    }

    init(
        push destination: PushDestination,
        action: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.destination = .push(destination)
        self.action = action
        self.content = content
    }

    init(
        dismissType: DismissType,
        action: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.destination = .dismiss(dismissType)
        self.action = action
        self.content = content
    }

    var body: some View {
        Button(action: {
            router.route(to: destination)
            action?()
        }) {
            content()
                .contentShape(Rectangle())
        }
        .tint(.primary)
    }
}
