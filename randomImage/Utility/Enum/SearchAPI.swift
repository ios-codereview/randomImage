//
//  SearchAPI.swift
//  randomImage
//
//  Created by Hyeontae on 01/07/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import Foundation
import APIResource

enum NaverAPI {
    case search
    
    var resource: APIResource {
        switch self {
        case .search:
            var api = APIResource("https://openapi.naver.com/v1/search/image")
            api.headers = [SecretKey.id.key: SecretKey.id.value, SecretKey.secret.key: SecretKey.secret.value]
            return api
        }
    }
    
    var manager: APIManager {
        return APIManager(apiResource: self.resource)
    }
}

//private lazy var searchAPI: APIResource = {
//    var api = ImageSearchRequestAPI(urlString: "https://openapi.naver.com/v1/search/image")
//    api.headers = [SecretKey.id.key: SecretKey.id.value, SecretKey.secret.key: SecretKey.secret.value]
//    return api
//}()
//private lazy var apiManager: APIManager = {
//    let manager = APIManager(apiResource: self.searchAPI)
//    return manager
//}()
//
