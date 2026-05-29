//
//  PillView.swift
//  Secnds
//
//  Created by Michael Pace on 5/9/26.
//

import Foundation
import SwiftUI

struct PillView: View {
    private let label: String
    private let color: AppColor

    init(
        _ label: String,
        _ color: AppColor
    ) {
        self.label = label
        self.color = color
    }

    var body: some View {
        Text(label)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color.color)
            .foregroundStyle(.white)
            .clipShape(Capsule())
    }
}
