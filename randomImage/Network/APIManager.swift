//
//  APIManager.swift
//  randomImage
//
//  Created by Hyeontae on 01/06/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import Foundation
import RequestBuilder

class APIManager {
    
    var apiResource: APIResource
    lazy var urlRequest: URLRequest = {
        return RequestBuilder(apiResource: self.apiResource).build()
    }()
    
    init(apiResource: APIResource) {
        self.apiResource = apiResource
    }
    
    func images() {
        
    }
}
