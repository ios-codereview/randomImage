//
//  LoadingCell.swift
//  randomImage
//
//  Created by HyeonTae on 12/06/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import UIKit

class LoadingCell: UITableViewCell, Reusable {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
