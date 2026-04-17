//
//  Networking.swift
//  HikeApp
//
//  Created by shashank atray on 17/04/26.
//

import Foundation
import Alamofire

protocol BaseNetworkProtocol {
    func performNetworkRequest<T: ApiRequest>(_ request: T) async throws -> T.ResponseType
}

actor Networking: GlobalActor, BaseNetworkProtocol {
    static let shared = Networking()
    private init() {}
    
    func performNetworkRequest<T: ApiRequest>(_ request: T) async throws -> T.ResponseType {
        
        var urlRequest = URLRequest(url: request.url)
        urlRequest.httpMethod = request.method
        urlRequest.httpBody = request.body
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(T.ResponseType.self, from: data)
            return decodedResponse
        } catch {
            throw error
        }
    }
}
