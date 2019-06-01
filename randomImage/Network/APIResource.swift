//
//  APIService.swift
//  randomImage
//
//  Created by Hyeontae on 30/05/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

protocol APIResource {
    var urlString: String? { get set }
    var url: URL? { get set }
    var host: String? { get set }
    /// path component와 다르다 
    var paths: [String]? { get set }
    var method: HTTPMethod { get set }
    var query: [String: String?]? { get set }
//    var body: [String: Any]? { get set }
//    var headers: [String: Any]? { get set }
}
