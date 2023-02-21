//
//  OpenAINetworkManager.swift
//  ChatGPTSwiftUI
//
//  Created by Djallil on 2023-02-16.
//

import Foundation

enum EndPoint: String {
    case completions
    
    func getURLForEndPoint(_ baseURL: URL) -> URL{
        return baseURL.appendingPathComponent(self.rawValue)
    }
}

class OpenAINetworkManager {
    static let shared = OpenAINetworkManager()
    
    private lazy var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
    
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    private let baseURL = URL(string:"https://api.openai.com/v1/")!
    private let apiKey = "Your API Key"
    
    func talkToGPT(from prompt: String) async throws -> [AIResponse] {
        let url = EndPoint.completions.getURLForEndPoint(baseURL)
        var request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        request.httpMethod = "POST"
        // HTTP Header for auth
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = OpenAIRequest(prompt: prompt)
        let bodyRequest = try? encoder.encode(body)
        request.httpBody = bodyRequest
        let (data, _) = try await URLSession.shared.data(for: request)
        let apiResponse = try? JSONDecoder().decode(OpenAIResponse.self, from: data)
        let response = apiResponse?.choices.filter({!$0.text.isEmpty}).compactMap({ answer in
            AIResponse(id: apiResponse?.id ?? UUID().uuidString, responseText: answer.text)
        })

        return response ?? []
    }
}

struct AIResponse: Identifiable {
    let id: String
    let responseText: String
}

struct OpenAIResponse: Decodable {
    let id: String
    let object: String?
    let created: Int?
    let model: String
    let choices: [GPTAnswer]
    let usage: Usage?
}

// MARK: - Choice
struct GPTAnswer: Decodable {
    let text: String
    let index: Int
    let logprobs: String?
    let finishReason: String?
}

// MARK: - Usage
struct Usage: Decodable {
    let promptTokens, completionTokens, totalTokens: Int?
}

struct OpenAIRequest: Encodable {
    let model = "text-davinci-003"
    let prompt: String
    let max_tokens: Int = 1024
    let temperature = 0
    let stream = false
    
    init(prompt: String, histories: [DiscussionHistory] = []) {
        if !histories.isEmpty {
            var prompt = OpenAIRequest.basePrompt
            histories.forEach { history in
                prompt.append("\(history.user.name): \(history.text)\n\n\n")
            }
            self.prompt = prompt
        } else {
            self.prompt = OpenAIRequest.basePrompt + "\(prompt)\n\n\n ChatGPT: \n"
        }
    }
    
    static let basePrompt = "You are AI language model called ChatGPT designed to respond to text-based inputs and provide helpful, concise and informative responses to the best of your ability. \n\n\n."

}

struct DiscussionHistory {
    let user: User
    let text: String
}
