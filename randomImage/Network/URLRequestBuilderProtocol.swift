//
//  URLRequestBuilderProtocol.swift
//  randomImage
//
//  Created by Hyeontae on 29/05/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import UIKit

// TODO: 현재는 Get 부분만 생각함
protocol URLRequestBuilderProtocol {
//    var apiResource: APIResource { get set }
//    var cachePolicy: URLRequest.CachePolicy? { get set }
//    var timeoutInterval: TimeInterval? { get set }
    
    func decomposeURLString()
    func urlString(urlString: String) -> URLRequestBuilderProtocol
    func host(host: String) -> URLRequestBuilderProtocol
    func path(paths: [String]) -> URLRequestBuilderProtocol
    func method(method: HTTPMethod) -> URLRequestBuilderProtocol
    func query(query: [String: String?]?) -> URLRequestBuilderProtocol
}
