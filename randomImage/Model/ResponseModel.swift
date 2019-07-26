//
//  ResponseModel.swift
//  randomImage
//
//  Created by Hyeontae on 08/06/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import Foundation

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
