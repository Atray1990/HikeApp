//
//  NetworkingConstants.swift
//  HikeApp
//
//  Created by shashank atray on 17/04/26.
//

import Foundation

enum API {
    static var baseURL: URL {
        return try! URL(string: "https://" + Configuration.value(for: "BASE_URL"))!
    }
}

enum EndPoints {
    static var getCharacter: String {
        return "/character/?page="
    }

    static var searchCharacter: String {
        return "/character/?name="
    }
}
