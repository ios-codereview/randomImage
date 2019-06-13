//
//  UINib.swift
//  randomImage
//
//  Created by Hyeontae on 09/06/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import UIKit

extension UINib {
    convenience init(_ nibClass: AnyClass) {
        let mainBundle = Bundle(identifier: "com.onemoon.studio.randomImage")
        self.init(nibName: String(describing: nibClass), bundle: mainBundle)
    }
}
