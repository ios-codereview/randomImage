//
//  ImageCollectionViewCell.swift
//  randomImage
//
//  Created by Hyeontae on 14/06/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell, Reusable {

    @IBOutlet weak var imageTitle: UILabel!
    @IBOutlet weak var centerImageView: UIImageView!
    var imageWorkItem: DispatchWorkItem?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageWorkItem?.cancel()
        centerImageView.image = UIImage(named: "defaultImage")
    }
    
    func configure(_ title: String) {
        imageTitle.text = title
    }
    
    func confifure(_ image: UIImage) {
        centerImageView.image = image
    }

}
