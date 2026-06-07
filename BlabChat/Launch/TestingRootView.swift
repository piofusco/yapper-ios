//
//  TestingRootView.swift
//  Secnds
//

import SwiftUI

struct TestingRootView: View {
    @State private var isSpinning = false
    @State private var messageIndex = 0
    @State private var dotCount = 0
    @State private var scale = 1.0

    private let messages = [
        "Definitely not spying on your code",
        "Asserting dominance over your bugs",
        "Poking the view models",
        "Checking if nil means nil",
        "Counting to 0",
        "Making sure 2 + 2 still equals 4",
        "Blaming the intern",
        "Reading the docs (lol)",
        "Googling the error message",
        "It works on my machine",
    ]

    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 32) {
                ZStack {
                    // Orbiting dots
                    ForEach(0..<6, id: \.self) { i in
                        Circle()
                            .fill(orbitColor(for: i))
                            .frame(width: 10, height: 10)
                            .offset(y: -60)
                            .rotationEffect(.degrees(Double(i) * 60 + (isSpinning ? 360 : 0)))
                            .animation(
                                .linear(duration: 2.0)
                                .repeatForever(autoreverses: false)
                                .delay(Double(i) * 0.05),
                                value: isSpinning
                            )
                    }

                    Image(systemName: "flask.fill")
                        .font(.system(size: 72))
                        .foregroundStyle(.tint)
                        .scaleEffect(scale)
                        .animation(
                            .easeInOut(duration: 0.8)
                            .repeatForever(autoreverses: true),
                            value: scale
                        )
                }
                .frame(width: 140, height: 140)

                VStack(spacing: 8) {
                    Text("Running Tests")
                        .font(.title2.bold())
                        .foregroundStyle(.primary)

                    Text(messages[messageIndex] + String(repeating: ".", count: dotCount))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .contentTransition(.numericText())
                        .animation(.default, value: messageIndex)
                        .frame(maxWidth: 280)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .task {
            isSpinning = true
            scale = 1.15
        }
        .task {
            while true {
                try? await Task.sleep(for: .seconds(0.4))
                dotCount = (dotCount + 1) % 4
            }
        }
        .task {
            while true {
                try? await Task.sleep(for: .seconds(2.5))
                messageIndex = (messageIndex + 1) % messages.count
            }
        }
    }

    private func orbitColor(for index: Int) -> Color {
        [Color.blue, .purple, .pink, .orange, .yellow, .green][index % 6]
    }
}

#Preview {
    TestingRootView()
}
