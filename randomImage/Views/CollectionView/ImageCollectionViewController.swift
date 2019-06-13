//
//  ImageCollectionViewController.swift
//  randomImage
//
//  Created by Hyeontae on 07/06/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import UIKit

class ImageCollectionViewController: UIViewController {
   
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func setCollectionView() {
        collectionView.register(ImageCollectionViewCell.self)
    }

    
    
}

extension ImageCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "test", for: indexPath)
        
        return cell
    }
    
    
}

extension ImageCollectionViewController: UICollectionViewDelegate {
    
}

extension ImageCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.zero
    }
}
