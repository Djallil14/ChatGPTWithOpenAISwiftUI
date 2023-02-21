//
//  MessageAndUserModel.swift
//  ChatGPTSwiftUI
//
//  Created by Djallil on 2023-02-16.
//
import Foundation

struct User: Equatable, Hashable {
    let name: String
    let isGPT3: Bool
    let icon: String
    
    static let user: User = .init(name: "Me", isGPT3: false, icon: "user")
    static let gpt3: User = .init(name: "ChatGPT", isGPT3: true, icon: "gpt")
}

struct Message: Identifiable, Equatable, Hashable {
    let id = UUID()
    let user: User
    let message: String
    
    static let sample: [Message] = [
        .init(user: .user, message: "Hello GPT3"),
        .init(user: .gpt3, message: "Hello You"),
        .init(user: .user, message: "What's up bro ?"),
        .init(user: .gpt3, message: "Nothing i'm an just AI")
    ]
}
