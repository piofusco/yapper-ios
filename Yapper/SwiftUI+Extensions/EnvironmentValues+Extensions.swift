//
//  EnvironmentValues+Extensions.swift
//  Secnds
//
//  Created by Michael Pace on 5/21/26.
//

import SwiftUI

extension EnvironmentValues {
    var isLandscape: Bool {
        (verticalSizeClass == .compact && horizontalSizeClass == .compact) ||
        (verticalSizeClass == .compact && horizontalSizeClass == .regular)
    }

    var isPortrait: Bool {
        (verticalSizeClass == .regular && horizontalSizeClass == .compact) ||
        verticalSizeClass == .regular && horizontalSizeClass == .regular
    }
}
