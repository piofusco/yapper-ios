//
//  ConversationViewModel.swift
//  BlabChat
//
//  Created by Michael Pace on 6/6/26.
//

import Foundation
import Observation

@Observable
@MainActor
final class ConversationViewModel {
    var inputText = ""
    var isLoading = false

    func send(
        to recipient: String,
        using chatService: any ChatService
    ) async throws {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        let text = inputText
        inputText = ""
        isLoading = true
        defer { isLoading = false }

        try await chatService.send(text: text, to: recipient)
    }
}
