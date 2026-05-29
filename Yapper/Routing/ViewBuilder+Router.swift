//
//  Untitled.swift
//  Secnds
//
//  Created by Michael Pace on 1/14/26.
//

import SwiftData
import SwiftUI

@MainActor
@ViewBuilder
func view(
    for destination: PushDestination,
) -> some View {
    switch destination {
        case .example: EmptyView()
    }
}

@MainActor
@ViewBuilder
func view(for destination: FullScreenDestination) -> some View {
    Group {
        switch destination {
            case .example: EmptyView()
        }
    }
}
