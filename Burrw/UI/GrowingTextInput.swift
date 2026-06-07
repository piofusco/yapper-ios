//
//  GrowingTextInput.swift
//  Burrw
//
//  Created by Michael Pace on 6/4/26.
//

import SwiftUI

struct GrowingTextInput: View {
    @Binding var text: String
    var onSubmit: () -> Void

    private let minHeight: CGFloat = 36

    @State private var measuredHeight: CGFloat = 36

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ZStack(alignment: .leading) {
                Text(text)
                    .font(.body)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .background(
                        GeometryReader { geo in
                            Color.clear.onAppear {
                                measuredHeight = max(geo.size.height, minHeight)
                            }
                            .onChange(of: text) {
                                measuredHeight = max(geo.size.height, minHeight)
                            }
                        }
                    )
                    .hidden()
                TextField("whatever", text: $text, axis: .vertical)
                    .font(.body)
                    .scrollContentBackground(.hidden)
                    .padding(12)
                    .lineLimit(nil)
                    .frame(minHeight: 36)
            }

            Button {
                guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                onSubmit()
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 30))
                    .foregroundStyle(.blue)
            }
            .padding(.trailing, 4)
            .padding(.bottom, 3)
        }
        .background(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
    }
}

#Preview {
    @Previewable @State var text: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec euismod, nisi vitae fermentum vulputate, elit elit ultrices mauris, ac euismod elit urna ac elit. "

    VStack {
        GrowingTextInput(text: $text) {
            print("Button tapped")
        }
    }
}
