//
//  Dictionary+Extension.swift
//  HikeApp
//
//  Created by shashank atray on 17/04/26.
//

import Foundation
import Alamofire

extension Dictionary where Key == String, Value == String {
    func toHeader() -> HTTPHeaders {
        var headers: HTTPHeaders = [:]
        for (key, value) in self  {
            headers.add(name: key, value: value)
        }
        return headers
    }
}
