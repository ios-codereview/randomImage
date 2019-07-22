//
//  ImageTableViewCell.swift
//  randomImage
//
//  Created by Hyeontae on 07/06/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell, Reusable {
    
    @IBOutlet weak var imageTitle: UILabel! 
    @IBOutlet weak var centerImageView: UIImageView!
    var imageWorkItem: DispatchWorkItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        imageWorkItem?.cancel()
        centerImageView.image = UIImage(named: "defaultImage")
    }
    
    func configure(_ title: String) {
        imageTitle.text = title
    }
    
    func configure(_ image: UIImage) {
        centerImageView.image = image
    }
    
}
