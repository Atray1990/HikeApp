//
//  GetCharacterListingRequest.swift
//  HikeApp
//
//  Created by shashank atray on 17/04/26.
//

import Foundation
struct GetCharacterListingRequest: ApiRequest {
    var queryParameters: [String : String]?
    var nextUrlString: String?
    
    init(nextUrlString: String? = nil) {
        self.nextUrlString = nextUrlString
    }
    
    typealias ResponseType = RickAndMortyCharacterResponse
    
    var url: URL {
        guard let nextUrlString,
              let nextURL = URL(string: nextUrlString) else {
            return URL(string: "\(API.baseURL)\(EndPoints.getCharacter)")!
        }
        
        return nextURL
    }
    
    var method: String {
        return "GET"
    }
}
