//
//  ApiRequest.swift
//  HikeApp
//
//  Created by shashank atray on 17/04/26.
import Foundation

protocol ApiRequest {
    associatedtype ResponseType: Decodable

    var url: URL { get }
    var method: String { get }
    var headers: [String: String]? { get }
    var body: Data? { get }

}

extension ApiRequest {
    var method: String { return "GET" }
    var headers: [String: String]? { return nil }
    var body: Data? { return nil }
}
