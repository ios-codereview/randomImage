//
//  APIManager.swift
//  randomImage
//
//  Created by Hyeontae on 01/06/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import Foundation

class APIManager {
    
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
    func getDate() {
        let urlRequest = URLRequestBuilder(apiResource: managerApiResource, nil, nil).build()
        print("!")
        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            print("2")
            if let error = error {
                print(error)
                return
            }

            print(3)
            print(data)

        }
    }
}

