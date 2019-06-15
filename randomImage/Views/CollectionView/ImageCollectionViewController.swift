//
//  ImageCollectionViewController.swift
//  randomImage
//
//  Created by Hyeontae on 07/06/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import UIKit

class ImageCollectionViewController: UIViewController {
   
    // MARK: - IBOutlet
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchButton: UIBarButtonItem! {
        didSet {
            searchButton.target = self
            searchButton.action = #selector(didTapSearchButton)
        }
    }
    
    // MARK: - Property
    
    private let insetsForSections = UIEdgeInsets(top: 5.0,
                                                 left: 5.0,
                                                 bottom: 5.0,
                                                 right: 5.0)
    private let minimumSpacingForRow: CGFloat = 5.0
    private let widthBetweenItems: CGFloat = 5.0
    private let itemsPerRow: CGFloat = 2.0
    private let testData = Array<String>.init(repeating: "collectionViewCell", count: 50)
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CollectionView"
        navigationController?.navigationBar.prefersLargeTitles = true
        setCollectionView()
    }
    
    // MARK: - Method
    
    private func setCollectionView() {
        collectionView.register(ImageCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    @objc private func didTapSearchButton() {
        print("hello")
        // 이렇게 하면 사라지기는 한다.
        navigationController?.navigationBar.prefersLargeTitles = false
        
    }
}

// MARK: - UICollectionViewDataSource

extension ImageCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell
            else {fatalError("collectionView cell is not ImageCollectionViewCell")}
        cell.iamgeTitle.text = testData[indexPath.row]
        cell.centerImageView.image = #imageLiteral(resourceName: "defaultImage")
        return cell
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension ImageCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = (itemsPerRow + 1) * insetsForSections.left
        let widthPerItem = (collectionView.bounds.width - paddingSpace) / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    // collectionView의 items들을 감싸는 inset에 대한 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insetsForSections
    }
    
    // 아이템들 사이에 대한 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return widthBetweenItems
    }
    
    // 만약 vertical Scrolling이라면 row 사이의 간격 horizontal 이라면 column 사이의 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumSpacingForRow
    }
}

// MARK: - UICollectionViewDelegate

extension ImageCollectionViewController: UICollectionViewDelegate {
    
}
