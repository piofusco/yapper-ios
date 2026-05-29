//
//  FormCellView.swift
//  Secnds
//
//  Created by Michael Pace on 5/26/26.
//

import SwiftUI

struct FormCellView: View {
    let icon: Icon?
    let iconBackgroundColor: AppColor?
    let leftContent: AnyView
    let rightContent: AnyView
    let action: (() -> Void)?

    init(
        icon: Icon? = nil,
        iconBackgroundColor: AppColor? = nil,
        @ViewBuilder leftContent: () -> some View,
        @ViewBuilder rightContent: () -> some View = { FormCellChevron() },
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.iconBackgroundColor = iconBackgroundColor
        self.leftContent = AnyView(leftContent())
        self.rightContent = AnyView(rightContent())
        self.action = action
    }

    var body: some View {
        if let action {
            row.onTapGesture { action() }
        } else {
            row
        }
    }

    private var row: some View {
        HStack {
            if let icon, let iconBackgroundColor {
                Image(icon.rawValue)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .padding(5)
                    .foregroundStyle(.white)
                    .background(iconBackgroundColor.color)
                    .clipShape(.rect(cornerRadius: 10))
                    .padding(.vertical, 1)
                    .padding(.trailing, 5)
            }
            leftContent
            Spacer()
            rightContent
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }
}

struct FormCellChevron: View {
    var body: some View {
        Image(Icon.chevronRight.rawValue)
            .resizable()
            .frame(width: 20, height: 20)
            .foregroundStyle(.secondary)
    }
}

#Preview {
    Form {
        Section("Section Header") {
            FormCellView(
                icon: .cloud,
                iconBackgroundColor: .blue
            ) {
                Text("iCloud Backups")
            } action: {
                print("Action tapped")
            }

            FormCellView(
                icon: .cloud,
                iconBackgroundColor: .red,
                leftContent: { Text("iCloud Backups") },
                rightContent: { PillView("100", .gray) },
                action: { print("Action tapped") }
            )
        }
        Section("Section Header") {
            FormCellView(
                icon: .cloud,
                iconBackgroundColor: .red,
                leftContent: { Text("iCloud Backups") },
                rightContent: { PillView("100", .gray) },
                action: { print("Action tapped") }
            )
        }
    }
}
