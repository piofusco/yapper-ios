//
//  ChatMessage.swift
//  Yapper
//
//  Created by Michael Pace on 6/6/26.
//

import Foundation

struct ChatMessage: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let partner: String
    let isSent: Bool
    let timestamp: Date
}
