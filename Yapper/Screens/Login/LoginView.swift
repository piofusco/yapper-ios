//
//  LoginView.swift
//  Yapper
//
//  Created by Michael Pace on 6/6/26.
//

import SwiftUI

struct LoginView: View {
    @Environment(Router.self) private var router

    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .center) {
                Image(Icon.logo.rawValue)
                    .resizable()
                    .frame(width: 100, height: 100)
                Text("Welcome To Yapper.")
                    .fontWeight(.semibold)
                    .font(.title)
            }
            Spacer()
            Button {

            } label: {
                Text("Sign Up")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(AppColor.orange.color)
                    .clipShape(.capsule)
                    .contentShape(.capsule)
            }
            Button {

            } label: {
                Text("Login")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(AppColor.orange.color)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(.white)
                    .clipShape(.capsule)
                    .contentShape(.capsule)
                    .overlay {
                        Capsule()
                            .strokeBorder(AppColor.orange.color, lineWidth: 2)
                    }
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 32)
    }
}

#Preview {
    NavigationStack {
        LoginView()
    }
    .environment(Router(level: 0, identifierTab: nil))
}
