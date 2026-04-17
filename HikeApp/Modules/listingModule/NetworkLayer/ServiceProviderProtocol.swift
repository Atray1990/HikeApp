//
//  ServiceProviderProtocol.swift
//  HikeApp
//
//  Created by shashank atray on 17/04/26.
//

import Foundation

protocol ServiceProviderProtocol {
    var networkProvider: BaseNetworkProtocol { get }
    func getAllCharacterListing(nextUrlString: String?, searchString: String?) async -> RickAndMortyCharacterResponse?
}

extension ServiceProviderProtocol {
    
    func getAllCharacterListing( nextUrlString: String?, searchString: String?) async -> RickAndMortyCharacterResponse? {
        
        do {
            if let searchString, !searchString.isEmpty {
                let request = GetCharacterSearchRequest(searchString: searchString)
                return try await networkProvider.performNetworkRequest(request)
            } else {
                let request = GetCharacterListingRequest(nextUrlString: nextUrlString)
                return try await networkProvider.performNetworkRequest(request)
            }
        } catch {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
}

final class GetChracterServiceManager: ServiceProviderProtocol {
    
    let networkProvider: BaseNetworkProtocol
    init(networkProvider: BaseNetworkProtocol = Networking.shared) {
        self.networkProvider = networkProvider
    }
}
