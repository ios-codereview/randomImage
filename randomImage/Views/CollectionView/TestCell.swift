//
//  TestCell.swift
//  randomImage
//
//  Created by HyeonTae on 12/06/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import UIKit

class TestCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton! 
    @IBOutlet weak var stackView: UIStackView!
    
    @IBAction func buttonDidTapped() {
        stackView.isHidden = true
    }
}


