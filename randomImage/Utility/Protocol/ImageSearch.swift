//
//  ImageSearch.swift
//  randomImage
//
//  Created by HyeonTae on 16/06/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import UIKit

typealias ImageSearchController = UIViewController & ImageSearch

protocol ImageSearch {
    var rootPageViewController: MainPageViewController! { get set }
    var isImageDataChanged: Bool { get set }
    func reloadImageData()
}
