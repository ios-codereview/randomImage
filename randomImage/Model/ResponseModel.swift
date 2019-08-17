//
//  ResponseModel.swift
//  randomImage
//
//  Created by Hyeontae on 08/06/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import Foundation

// Review: [Refactoring] Codable -> Decodable 을 사용하는건 어떨까요?
// encode를 사용하지 않고 decode만 사용하기 때문에 적절할 것 같습니다.
struct NaverImageSearchResult: Codable {
    var lastBuildDate: String
    var total: Int
    var start: Int
    var display: Int
    var items: [ImageItem]
}

struct ImageItem: Codable {
    var title: String
    var link: String // 전체 이미지
    var thumbnail: String // thumbnail 이미지
    var sizeheight: String
    var sizewidth: String
}
