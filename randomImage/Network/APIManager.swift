//
//  APIManager.swift
//  randomImage
//
//  Created by Hyeontae on 01/06/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import Foundation

class APIManager<JSONModel: Codable> {
    
    var managerApiResource: TestResource
    //static 자체가 lazy 이기 때문에 lazy를 쓰지 않아도 된다.
    lazy var urlSession = {
        // TODO: Configuration
       return URLSession(configuration: .default)
    }()
    
    init(resource: TestResource) {
        self.managerApiResource = resource
    }
    
    // TODO: Completion
    func getSimpleDate(completion: @escaping (_ data: JSONModel?, _ response: URLResponse?, _ error: Error?) -> Void)  {
        let urlRequest = URLRequestBuilder(apiResource: managerApiResource, nil, nil).build()
        let datatask = urlSession.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(nil, response, error)
            }
            
            if let data = data {
                do {
                    let model: JSONModel = try JSONDecoder().decode(JSONModel.self, from: data)
                    completion(model, response, nil)
                } catch {
                    completion(nil, response, error)
                }
            }
            
            completion(nil, response, error)
        }
        datatask.resume()
    }
}

