//
//  MessageExchangeView.swift
//  ChatGPTSwiftUI
//
//  Created by Djallil on 2023-02-16.
//

import SwiftUI

struct MessageExchangeView: View {
    @Binding var messages: [Message]
    @Binding var waitingForGPT: Bool
    var body: some View {
        LazyVStack {
            ForEach(messages) { message in
                MessageRowView(message: message)
                    .id(message)
                    .shadow(color:.black.opacity(0.2),radius: 2, x: 2, y: 4)
            }
            if waitingForGPT {
                MessageLoadingRowView(user: .gpt3)
                    .opacity(waitingForGPT ? 1 : 0)
            }
        }
    }
}

struct MessageExchangeView_Previews: PreviewProvider {
    static var previews: some View {
        MessageExchangeView(messages: .constant(Message.sample), waitingForGPT: .constant(true))
    }
}

struct MessageLoadingRowView: View {
    let user: User
    @State private var firstBounce: CGFloat = 0
    @State private var secondBounce: CGFloat = 0
    @State private var thirdBounce: CGFloat = 0

    private let timer = Timer.publish(every: 0.3, on: .main, in: .default).autoconnect()
    var body: some View {
        HStack {
            VStack(spacing: 2) {
                Image(user.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(.white)
                    .frame(width: 22, height: 22)
                    .clipShape(Circle())
                    .padding(2)
                    .background(Color.green.clipShape(Circle()))
                Text(user.name)
                    .font(.caption2)
                    .bold()
            }
            .padding(8)
            HStack(spacing: 4) {
                Circle()
                    .frame(width: 8, height: 8)
                    .offset(y: firstBounce)
                Circle()
                    .frame(width: 8, height: 8)
                    .offset(y: secondBounce)
                Circle()
                    .frame(width: 8, height: 8)
                    .offset(y: thirdBounce)
            }
            .foregroundStyle(.white)
            .padding()
            .background(Color.green)
            .cornerRadius(12)
            .padding(.horizontal, 8)
            Spacer()
        }
        .onReceive(timer, perform: { _ in
            switch (firstBounce, secondBounce, thirdBounce) {
            case (0,0,0):
                withAnimation(.spring()) {
                    firstBounce = 4
                    secondBounce = -4
                    thirdBounce = -4
                }
            case (4,-4,-4):
                withAnimation(.spring()) {
                    firstBounce = -4
                    secondBounce = 4
                    thirdBounce = -4
                }
            case (-4,4,-4):
                withAnimation(.spring()) {
                    firstBounce = -4
                    secondBounce = -4
                    thirdBounce = 4
                }
            case (-4,-4,4):
                withAnimation(.spring()) {
                    firstBounce = 4
                    secondBounce = -4
                    thirdBounce = -4
                }
            default:
                return
            }
        })
        .onDisappear {
            timer.upstream.connect().cancel()
        }
    }
}
