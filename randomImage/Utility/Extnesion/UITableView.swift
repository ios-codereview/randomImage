//
//  UITableView.swift
//  randomImage
//
//  Created by HyeonTae on 12/06/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import UIKit

extension UITableView {
    
    @available(iOS 5.0, *)
    func registerReusableCell<ReusableCell: UITableViewCell & Reusable >(_ reusableCell: ReusableCell.Type) {
        register(UINib(reusableCell), forCellReuseIdentifier: reusableCell.reuseIdentifier)
    }
}
