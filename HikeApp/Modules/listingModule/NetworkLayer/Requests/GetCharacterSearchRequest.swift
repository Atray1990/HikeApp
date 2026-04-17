//
//  GetCharacterSearchRequest.swift
//  HikeApp
//
//  Created by shashank atray on 17/04/26.
//

import Foundation
struct GetCharacterSearchRequest: ApiRequest {
    var queryParameters: [String : String]?
    var searchString: String = ""
    var nextUrlString: String?
    
    init(searchString: String = "", nextUrlString: String? = nil) {
        self.searchString = searchString
        self.nextUrlString = nextUrlString
    }
    
    typealias ResponseType = RickAndMortyCharacterResponse
    
    var url: URL {
        guard let nextUrlString,
              let nextURL = URL(string: nextUrlString) else {
            return URL(string: "\(API.baseURL)\(EndPoints.searchCharacter)\(searchString)")!
        }
        
        return nextURL
    }
    
    var method: String {
        return "GET"
    }
}
