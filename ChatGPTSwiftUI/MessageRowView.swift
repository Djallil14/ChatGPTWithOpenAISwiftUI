//
//  MessageRowView.swift
//  ChatGPTSwiftUI
//
//  Created by Djallil on 2023-02-16.
//

import SwiftUI

struct MessageRowView: View {
    let message: Message
    var isGPT: Bool {
        message.user.isGPT3
    }
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            if !isGPT {
                messageView()
            }
            VStack(spacing: 2) {
                Image(message.user.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(.white)
                    .frame(width: 22, height: 22)
                    .clipShape(Circle())
                    .padding(2)
                    .background(isGPT ? Color.purple.clipShape(Circle()) : Color.blue.clipShape(Circle()))
                Text(message.user.name)
                    .font(.caption2)
                    .bold()
            }
            .padding(8)
            if isGPT {
                messageView()
            }
        }
    }
    
    @ViewBuilder
    private func messageView() -> some View {
        HStack {
            Text(message.message)
                .font(.body)
                .multilineTextAlignment(.leading)
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal)
        .background(isGPT ? Color.purple : Color.blue)
        .cornerRadius(12)
        .padding(8)
    }
}

struct MessageRowView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MessageRowView(message: Message.sample[0])
            MessageRowView(message: Message.sample[1])
        }
    }
}
