//
//  ChatGPTConversationViewModel.swift
//  ChatGPTSwiftUI
//
//  Created by Djallil on 2023-02-16.
//

import SwiftUI

@MainActor
class ChatGPTConversationViewModel: ObservableObject {
    @Published var messages: [Message] = []
    private var networkManager = OpenAINetworkManager.shared
    @Published var waitingForGPTAnswer = false
    
    func sendRequestToGPT(prompt: String) {
        withAnimation(.easeInOut) {
            waitingForGPTAnswer = true
        }
        messages.append(.init(user: .user, message: prompt))
        Task {
            let response = try? await networkManager.talkToGPT(from:prompt)
            if let response = response {
                response.forEach { response in
                    messages.append(.init(user: .gpt3, message: response.responseText))
                }
            }
            waitingForGPTAnswer = false
        }
    }
}
