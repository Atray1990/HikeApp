//
//  HikeAppTests.swift
//  HikeAppTests
//
//  Created by shashank atray on 17/04/26.
//



import XCTest
@testable import HikeApp
final class MockCharacterListingAPIManager: CharacterListingTaskProtocol {
    
    var shouldReturnError = false
    var mockResponse: RickAndMortyCharacterResponse?
    var executeCallCount = 0
    
    func executeCharacterListingApi(nextUrlString: String?, searchString: String?) async -> RickAndMortyCharacterResponse? {
        executeCallCount += 1
        return shouldReturnError ? nil : mockResponse
    }
}

final class CharacterListingViewModelTests: XCTestCase {
    
    var viewModel: CharacterListingViewModelImpl!
    var mockAPI: MockCharacterListingAPIManager!
    
    override func setUp() {
        super.setUp()
        mockAPI = MockCharacterListingAPIManager()
        viewModel = CharacterListingViewModelImpl(apiManager: mockAPI)
    }
    
    override func tearDown() {
        viewModel = nil
        mockAPI = nil
        super.tearDown()
    }
}
