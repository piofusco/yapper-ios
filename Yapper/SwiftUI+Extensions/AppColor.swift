//
//  AppColor.swift
//  Secnds
//
//  Created by Michael Pace on 5/9/26.
//

import SwiftUI

enum AppColor: String, CaseIterable, Codable, Identifiable {
    case blue     = "#007AFF"
    case gray     = "#8E8E93"
    case green    = "#34C759"
    case magenta  = "#FF2D9B"
    case orange   = "#FF9500"
    case purple   = "#AF52DE"
    case red      = "#FF3B30"
    case teal     = "#5AC8FA"
    case violet   = "#5856D6"
    case yellow   = "#FFCC00"

    var id: String { rawValue }

    var color: Color { Color(hex: rawValue) }

    var displayName: String {
        switch self {
            case .blue: return "Blue"
            case .gray: return "Gray"
            case .green: return "Green"
            case .magenta: return "Magenta"
            case .orange: return "Orange"
            case .purple: return "Purple"
            case .red: return "Red"
            case .teal: return "Teal"
            case .violet: return "Violet"
            case .yellow: return "Yellow"
        }
    }

    var isLight: Bool {
        let hex = rawValue.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        // Relative luminance (WCAG formula)
        let luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return luminance > 0.5
    }

    var next: AppColor {
        let cases = Self.allCases
        guard let index = cases.firstIndex(of: self) else { return cases.first! }
        return cases[(index + 1) % cases.count]
    }

    init?(hex: String) {
        let normalized = hex.hasPrefix("#") ? hex : "#\(hex)"
        self.init(rawValue: normalized.uppercased())
    }
}
