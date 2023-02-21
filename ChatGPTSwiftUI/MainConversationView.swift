//
//  ContentView.swift
//  ChatGPTSwiftUI
//
//  Created by Djallil on 2023-02-16.
//

import SwiftUI

struct MainConversationView: View {
    @State var textMessage: String = ""
    @StateObject var viewModel = ChatGPTConversationViewModel()
    var body: some View {
        ScrollViewReader { proxy in
            VStack {
                ScrollView {
                    LazyVStack {
                        MessageExchangeView(messages: $viewModel.messages, waitingForGPT: $viewModel.waitingForGPTAnswer)
                    }
                }
                HStack (spacing: 0){
                    TextField("User Message", text: $textMessage, prompt: Text("Write something here"))
                        .padding()
                        .background(Color.purple.opacity(0.2))
                        .cornerRadius(8)
                        .padding()
                        .autocorrectionDisabled()
                    Button(action: {
                        viewModel.sendRequestToGPT(prompt: textMessage)
                        textMessage = ""
                    }) {
                        Image(systemName: "arrow.right")
                            .bold()
                            .foregroundColor(.white)
                            .imageScale(.large)
                            .padding()
                            .background(Color.purple)
                            .cornerRadius(8)
                    }
                    .padding(.trailing)
                }
            }
            .padding()
            .onChange(of: viewModel.messages) { newValue in
                proxy.scrollTo(newValue.last, anchor: .bottom)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainConversationView()
    }
}
