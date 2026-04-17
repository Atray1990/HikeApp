//
//  CharacterListingTask.swift
//  HikeApp
//
//  Created by shashank atray on 17/04/26.
//

import Foundation

protocol CharacterListingTaskProtocol {
    var serviceProvider: ServiceProviderProtocol { get }
    func executeCharacterListingApi(nextUrlString: String?, searchString: String?) async -> RickAndMortyCharacterResponse?
}

extension CharacterListingTaskProtocol {
    
    func executeCharacterListingApi(nextUrlString: String? = nil, searchString: String?) async -> RickAndMortyCharacterResponse? {
        return await serviceProvider.getAllCharacterListing(nextUrlString: nextUrlString, searchString: searchString)
    }
    
}

final class CharacterListingTask: CharacterListingTaskProtocol {
    let serviceProvider: ServiceProviderProtocol
    
    init(serviceProvider: ServiceProviderProtocol = GetChracterServiceManager()) {
        self.serviceProvider = serviceProvider
    }
}
