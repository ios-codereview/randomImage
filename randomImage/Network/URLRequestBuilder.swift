//
//  URLRequestBuilder.swift
//  randomImage
//
//  Created by Hyeontae on 01/06/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import Foundation

class URLRequestBuilder<Resource: APIResource> {
    var apiResource: APIResource
    var cachePolicy: URLRequest.CachePolicy?
    var timeoutInterval: TimeInterval?
    
    init(apiResource: Resource, _ cachePolicy: URLRequest.CachePolicy?, _ timeout: TimeInterval?) {
        self.apiResource = apiResource
        self.cachePolicy = cachePolicy
        self.timeoutInterval = timeout
    }
}

extension URLRequestBuilder: URLRequestBuilderProtocol {
    func decomposeURLString() {
        // TODO: urlString이 없는 경우 에러 처리
        guard let urlString = apiResource.urlString else { return }
        // TODO: urlString으로 components 생성이 안되는 경우 에러 처리
        guard let components = URLComponents(string: urlString) else { return }
        apiResource.url = components.url
        apiResource.host = components.host
        if components.path.count > 0 {
            apiResource.paths = components.path.split(separator: "/").map { String($0) }
        }
        if let queryItems: [URLQueryItem] = components.queryItems {
            var queryDictionary: [String: String?] = [:]
            for item in queryItems {
                queryDictionary[item.name] = item.value
            }
            apiResource.query = queryDictionary
        }
        // important!
        apiResource.urlString = nil
    }
    
    // 아래 부분들 굳이 필요할까? 생각해보자 -> path를 조절하면 조절한 값으로 build하면 좋을 듯 ex) build()
    func urlString(urlString: String) -> URLRequestBuilderProtocol {
        apiResource.urlString = urlString
        return self
    }
    
    func host(host: String) -> URLRequestBuilderProtocol {
        apiResource.host = host
        return self
    }
    
    func path(paths: [String]) -> URLRequestBuilderProtocol {
        apiResource.paths = paths
        return self
    }
    
    func method(method: HTTPMethod) -> URLRequestBuilderProtocol {
        apiResource.method = method
        return self
    }
    
    func query(query: [String : String?]?) -> URLRequestBuilderProtocol {
        apiResource.query = query
        return self
    }
    
    // TODO: fatalError -> customError
    // TODO: 해당 함수들 다 제대로 찾아보기
    func build() -> URLRequest {
        
        /// 공통의 로직은 nested function으로 빼놓음
        func buildURLRequest(with url: URL) -> URLRequest {
            var cachePolicy: URLRequest.CachePolicy = .returnCacheDataElseLoad
            var timeoutInterval: TimeInterval = 5.0
            
            if let newCachedPolicy = self.cachePolicy {
                cachePolicy = newCachedPolicy
            }
            if let newTimeoutInterval = self.timeoutInterval {
                timeoutInterval = newTimeoutInterval
            }
            
            var resultRequest = URLRequest(url: url,
                                           cachePolicy: cachePolicy,
                                           timeoutInterval: timeoutInterval)
            resultRequest.httpMethod = apiResource.method.rawValue
            return resultRequest
        }
        
        /// 만약 유저가 간단하게 urlString 으로 만들고 싶은 경우 사용, 그렇지 않은 경우 host path등을 지정하면 적용할 수 있다.
        /// 조금 더 생각해보자 ! urlString 이 있어도 다른 값을 사용하고 싶은 경우는??
        if let urlString = apiResource.urlString, let url = URL(string: urlString) {
            return buildURLRequest(with: url)
        }
        
        /// urlString이 아닌 값을 조립하고 싶을 때
        guard let host = apiResource.host, var url = URL(string: host) else {
            fatalError("url from host is akward, check your host : \(apiResource.host)")
        }
        
        if let paths = apiResource.paths {
            if !paths.isEmpty {
                let path = paths.joined(separator: "/")
                url.appendPathComponent(path)
            }
        }
        
        var component = URLComponents(string: url.absoluteString)
        
        if let query = apiResource.query {
            var queryItems: [URLQueryItem] = []
            for queryItem in query {
                queryItems.append(URLQueryItem(name: queryItem.key, value: queryItem.value))
            }
            component?.queryItems = queryItems
        }
        
        guard let componentURL = component?.url else {
            fatalError("build component failed")
        }
        
        return buildURLRequest(with: componentURL)
    }
}
