//
//  ClearableTextField.swift
//  Secnds
//
//  Created by Michael Pace on 5/7/26.
//

import SwiftUI

struct ClearableTextField: View {
    let title: String
    @Binding var text: String
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack {
            TextField(title, text: $text)
                .focused($isFocused)
            if isFocused {
                Button {
                    text = ""
                } label: {
                    Image(Icon.circleXFilled.rawValue)
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    @Previewable @State var text = "HIIT Timer"
    Form {
        ClearableTextField(title: "Name", text: $text)
    }
}
