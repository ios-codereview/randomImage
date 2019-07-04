//
//  StoryBoardType.swift
//  randomImage
//
//  Created by Hyeontae on 04/06/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import UIKit

enum StoryBoardType: String {
    
    case main = "Main"
    case imageTableView = "ImageTableView"
    case imageCollectionView = "ImageCollectionView"
    case imageDetailView = "DetailView"
    
    var storyboard: UIStoryboard {
        let mainBundle = Bundle(identifier: "com.onemoon.studio.randomImage")
        return UIStoryboard(name: self.rawValue, bundle: mainBundle)
    }
    
    var initialViewController: UIViewController {
        let mainBundle = Bundle(identifier: "com.onemoon.studio.randomImage")
        guard let initialViewController = UIStoryboard(name: self.rawValue, bundle: mainBundle).instantiateInitialViewController() else {
            fatalError("Error with \(self) initial View Controller")
        }
        return initialViewController
    }
}
