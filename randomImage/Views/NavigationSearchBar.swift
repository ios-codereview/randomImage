//
//  navigationSearchBar.swift
//  randomImage
//
//  Created by Hyeontae on 15/06/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import UIKit

class NavigationSearchBar: UIView {

    // MARK: - IBOutlet
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cancelButton: UIButton! {
        didSet {
            cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        }
    }
    
    // MARK: - Property
    
    weak var delegate: UISearchBarDelegate? {
        didSet {
            searchBar.delegate = delegate
        }
    }
    
    var viewBackgroundColor: UIColor = .lightGray {
        didSet {
            backgroundColor = viewBackgroundColor
            searchBar.backgroundColor = viewBackgroundColor
        }
    }
    
    var nowSearching: Bool = false {
        didSet {
            if nowSearching {
                self.isHidden = false
            } else {
                self.isHidden = true
                searchBar.text = nil
            }
        }
    }
    
    var customCancelAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        searchBar.placeholder = "Search what Images U want"
    }
    
    @objc func cancelAction() {
        searchBar.resignFirstResponder()
        customCancelAction?()
        nowSearching = false
    }

}
