//
//  MockCharacterServiceProvider.swift
//  HikeAppTests
//
//  Created by shashank atray on 17/04/26.
//

import XCTest
@testable import HikeApp

final class MockCharacterServiceProvider: ServiceProviderProtocol {
    
    var networkProvider: BaseNetworkProtocol {
        fatalError("Not needed in mock")
    }
    
    // MARK: - Mock Controls
    var mockResponse: RickAndMortyCharacterResponse?
    var shouldReturnError: Bool = false
    var callCount = 0
    
    // Optional: track inputs
    var lastNextUrl: String?
    var lastSearchString: String?
    
    // MARK: - Mocked Method
    func getAllCharacterListing( nextUrlString: String?, searchString: String?) async -> RickAndMortyCharacterResponse? {
        
        callCount += 1
        lastNextUrl = nextUrlString
        lastSearchString = searchString
        
        if shouldReturnError {
            return nil
        }
        return mockResponse
    }
}
