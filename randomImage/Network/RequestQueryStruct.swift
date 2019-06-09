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
    var display: Int? = 10 
    var start: Int? = 1
    var sort: String?
    var filter: String?
    
    init(query: String) {
        self.query = query
    }
    
    func queryItems() -> [String: Any] {
        var queryItemsDictionary: [String: Any] = [:]
        let mirror = Mirror(reflecting: self)
        for child in mirror.children where child.label != nil && "\(child.value)" != "nil"{
            queryItemsDictionary.updateValue("\(NaverSearchQuery.unwrap(any: child.value))", forKey: child.label! )
        }
        
        return queryItemsDictionary
    }
    
//    query    string    Y    -    검색을 원하는 문자열로서 UTF-8로 인코딩한다.
//    display    integer    N    10(기본값), 100(최대)    검색 결과 출력 건수 지정
//    start    integer    N    1(기본값), 1000(최대)    검색 시작 위치로 최대 1000까지 가능
//    sort    string    N    string    정렬 옵션: sim (유사도순), date (날짜순)
//    filter    string    N    all (기본값),large, medium, small    사이즈 필터 옵션: all(전체), large(큰 사이즈), medium(중간 사이즈), small(작은 사이즈)
}
