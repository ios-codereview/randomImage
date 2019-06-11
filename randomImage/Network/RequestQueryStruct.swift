//
//  RequestQueryStruct.swift
//  randomImage
//
//  Created by Hyeontae on 08/06/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import Foundation

struct NaverSearchQuery: QueryStruct {
    
    var query: String
    var display: Int? = 20
    var start: Int? = 1
    var sort: String?
    var filter: String?
    
    init(query: String) {
        self.query = query
    }
    
    func queryItems(start page: Int) -> [String: Any] {
        var queryItemsDictionary: [String: Any] = [:]
        let mirror = Mirror(reflecting: self)
        for child in mirror.children where child.label != nil && "\(child.value)" != "nil"{
            if child.label! == "start" {
                queryItemsDictionary.updateValue("\(( page * display! ) + 1)",forKey: child.label!)
            } else {
                queryItemsDictionary.updateValue("\(NaverSearchQuery.unwrap(any: child.value))", forKey: child.label! )
            }
            
        }

        return queryItemsDictionary
    }
}
