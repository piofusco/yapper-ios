//
//  AlertView.swift
//  Secnds
//
//  Created by Michael Pace on 5/27/26.
//

import SwiftUI

struct AlertView: View {
    let content: AlertContent
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                VStack(spacing: 4) {
                    Text(content.title)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    if let message = content.message {
                        Text(message)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
                .padding(.bottom, 16)

                Divider()

                ForEach(content.actions) { action in
                    Button {
                        action.handler?()
                        onDismiss()
                    } label: {
                        Text(action.title)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 13)
                    }
                    .tint(action.role == .destructive ? .red : .accentColor)

                    if action.id != content.actions.last?.id {
                        Divider()
                    }
                }
            }
            .background(.background)
            .clipShape(.rect(cornerRadius: 14))
            .padding(.horizontal, 40)
            .shadow(color: .black.opacity(0.15), radius: 20)
        }
    }
}

#Preview {
    AlertView(
        content: AlertContent(
            title: "Failed to save",
            message: "The operation couldn't be completed.",
            actions: [.ok(), .cancel()]
        ),
        onDismiss: {}
    )
}
