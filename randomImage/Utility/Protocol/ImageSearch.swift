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
    // Review: [Refactoring] associatedtype으로 설계하는건 어떨까요?
    // 지금은 Compile error가 발생합니다.
    /*
    associatedtype ROOT where ROOT: MainPageViewController
    var rootPageViewController: ROOT { get set }
    */
    var rootPageViewController: MainPageViewController! { get set }
    var isImageDataChanged: Bool { get set }
    func reloadImageData()
}
