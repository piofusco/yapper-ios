//
//  MessageView.swift
//  Burrw
//
//  Created by Michael Pace on 6/4/26.
//

import SwiftUI

struct Message {
    let author: String
    let text: String
    let date: Date
}

struct MessageView: View {
    private let message: Message
    private let isSelf: Bool

    init(
        message: Message,
        isSelf: Bool = false
    ) {
        self.message = message
        self.isSelf = isSelf
    }

    var body: some View {
        if isSelf {
            VStack(alignment: .trailing) {
                HStack(alignment: .bottom) {
                    Spacer(minLength: 30)
                    Text(message.text)
                        .font(Font.subheadline)
                        .fontWeight(.medium)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(Color.orange.opacity(0.1))
                        }
                }
                .padding(.horizontal)
            }
        } else {
            VStack(alignment: .leading) {
                HStack(alignment: .bottom) {
                    profileImage
                    VStack(alignment: .leading) {
                        Text(message.author)
                            .font(Font.subheadline)
                            .fontWeight(.regular)
                            .fixedSize(horizontal: true, vertical: true)
                        Text(message.text)
                            .font(Font.subheadline)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.leading)
                            .padding(10)
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(Color.gray.opacity(0.1))
                            }
                    }
                    Spacer(minLength: 30)
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal)
            }
        }
    }

    private var profileImage: some View {
        Image(systemName: "person.fill")
            .resizable()
            .frame(width: 25, height: 25)
            .padding(5)
            .background(.gray)
            .foregroundColor(.white)
            .clipShape(Circle())
    }
}

#Preview {
    VStack {
        ScrollView {
            LazyVStack {
                MessageView(
                    message: Message(
                        author: "Miller",
                        text: "Y'all wanna do a FaceTime tomorrow night? Y'all wanna do a FaceTime tomorrow night? Y'all wanna do a FaceTime tomorrow night? Y'all wanna do a FaceTime tomorrow night? Y'all wanna do a FaceTime tomorrow night? Y'all wanna do a FaceTime tomorrow night? Y'all wanna do a FaceTime tomorrow night? Y'all wanna do a FaceTime tomorrow night?",
                        date: .now
                    ),
                    isSelf: true
                )
                MessageView(
                    message: Message(
                        author: "Miller",
                        text: "Y'all wanna do a FaceTime tomorrow night? Y'all wanna do a FaceTime tomorrow night? Y'all wanna do a FaceTime tomorrow night? Y'all wanna do a FaceTime tomorrow night?",
                        date: .now
                    )
                )
                MessageView(
                    message: Message(
                        author: "Miller",
                        text: "Y'all wanna do a FaceTime tomorrow night? Y'all wanna do a FaceTime tomorrow night? Y'all wanna do a FaceTime tomorrow night? Y'all wanna do a FaceTime tomorrow night?",
                        date: .now
                    )
                )
                MessageView(
                    message: Message(
                        author: "Miller",
                        text: "Y'all wanna do a FaceTime tomorrow night?",
                        date: .now
                    )
                )
            }
        }
    }
//    .frame(width: .infinity, height: .infinity)
}
