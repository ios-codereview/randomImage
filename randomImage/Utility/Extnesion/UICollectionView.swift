//
//  UICollectionView.swift
//  randomImage
//
//  Created by Hyeontae on 14/06/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import UIKit

extension UICollectionView {
    // Review: Good! protocol combine으로 사용하는건 좋은 것 같습니다.
    func register<ReusableCell: UICollectionViewCell & Reusable>(_ reusableCell: ReusableCell.Type) {
        register(UINib(reusableCell.self), forCellWithReuseIdentifier: reusableCell.reuseIdentifier)
    }
}
