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
        // Review: [Refactoring] String literal를 사용하는 것보다 Self을 참조하는건 어떨까요?
        // return UINib(nibName: String(describing: Self.self), bundle: nil)
        let mainBundle = Bundle(identifier: "com.onemoon.studio.randomImage")
        self.init(nibName: String(describing: nibClass), bundle: mainBundle)
    }
}
