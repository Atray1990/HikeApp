//
//  MockCharacterListingTask.swift
//  HikeAppTests
//
//  Created by shashank atray on 17/04/26.
//

import XCTest
@testable import HikeApp

final class MockCharacterListingTask: CharacterListingTaskProtocol {
    
    // Not really needed for mock, but required by protocol
    var serviceProvider: ServiceProviderProtocol {
        fatalError("Not used in MockCharacterListingTask")
    }
    
    // MARK: - Mock Controls
    var mockResponse: RickAndMortyCharacterResponse?
    var shouldReturnNil: Bool = false
    var callCount = 0
    
    // Track inputs
    var lastNextUrl: String?
    var lastSearchString: String?
    
    // MARK: - Mocked Method
    func executeCharacterListingApi( nextUrlString: String?, searchString: String?) async -> RickAndMortyCharacterResponse? {
        
        callCount += 1
        lastNextUrl = nextUrlString
        lastSearchString = searchString
        
        if shouldReturnNil {
            return nil
        }
        
        return mockResponse
    }
}
