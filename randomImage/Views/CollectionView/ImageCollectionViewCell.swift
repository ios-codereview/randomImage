//
//  ImageCollectionViewCell.swift
//  randomImage
//
//  Created by Hyeontae on 14/06/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell, Reusable {

    @IBOutlet weak var iamgeTitle: UILabel!
    @IBOutlet weak var centerImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
