//
//  NetworkingMock.swift
//  HikeAppTests
//
//  Created by shashank atray on 17/04/26.
//

import XCTest
@testable import HikeApp

final class MockNetworkProvider: BaseNetworkProtocol {
    
    // MARK: - Controls
    var shouldThrowError = false
    var mockData: Data?
    
    // Tracking
    var lastRequestURL: URL?
    var callCount = 0
    
    func performNetworkRequest<T: ApiRequest>(_ request: T) async throws -> T.ResponseType {
        
        callCount += 1
        lastRequestURL = request.url
        
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        
        guard let data = mockData else {
            fatalError("Mock data not set")
        }
        
        return try JSONDecoder().decode(T.ResponseType.self, from: data)
    }
}
