//
//  LoadingCollectionViewCell.swift
//  randomImage
//
//  Created by Hyeontae on 03/07/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import UIKit

class LoadingCollectionViewCell: UICollectionViewCell, Reusable {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
