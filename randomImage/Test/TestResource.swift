//
//  TestResource.swift
//  randomImage
//
//  Created by Hyeontae on 01/06/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import Foundation

struct TestResource: APIResource {
    
    var urlString: String?
    var url: URL?
    var host: String?
    var paths: [String]?
    var method: HTTPMethod = .get
    var query: [String : String?]?
    
    init(urlString: String) {
        self.urlString = urlString
    }
}
