//
//  NaverSearchQueryTest.swift
//  randomImageTests
//
//  Created by tskim on 15/08/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import Foundation
import XCTest
@testable import randomImage

class NaverSearchQueryTest: XCTestCase {
    
    func testMirror() {
        let query = NaverSearchQuery(query: "test").queryItems(start: 1)
        XCTAssertEqual(query, ["start": "21", "display": "20", "query": "test"])
    }
}
