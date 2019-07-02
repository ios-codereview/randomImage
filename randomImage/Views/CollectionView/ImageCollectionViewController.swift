//
//  ImageCollectionViewController.swift
//  randomImage
//
//  Created by Hyeontae on 07/06/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import UIKit

class ImageCollectionViewController: UIViewController, ImageSearch {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchButton: UIBarButtonItem! {
        didSet {
            searchButton.target = self
            searchButton.action = #selector(didTapSearchButton)
        }
    }
    
    // MARK: - Property
    
    weak var rootPageViewController: MainPageViewController!
    var isImageDataChanged: Bool = false
    
    private let insetsForSections = UIEdgeInsets(top: 5.0,
                                                 left: 5.0,
                                                 bottom: 5.0,
                                                 right: 5.0)
    private let minimumSpacingForRow: CGFloat = 5.0
    private let widthBetweenItems: CGFloat = 5.0
    private let itemsPerRow: CGFloat = 2.0
    private let largeTitleOffsetY: CGFloat = 6.0
    private var titleIsLarged = false
    private let testData = Array<String>.init(repeating: "collectionViewCell", count: 50)
    
    private lazy var navigationSearchBar: NavigationSearchBar = {
        guard let navigationBarHeight: CGFloat = navigationController?.navigationBar.frame.height,
        let navigationTintColor: UIColor = navigationController?.navigationBar.barTintColor else {
            fatalError("navigatin Controller and TintColor are inevitable")
        }
        guard let searchBar: NavigationSearchBar =
            UINib(NavigationSearchBar.self).instantiate(withOwner: self, options: nil).first as? NavigationSearchBar
            else { fatalError("fail to instantiate View with Nib") }
        searchBar.delegate = self
        searchBar.viewBackgroundColor = navigationTintColor
        searchBar.customCancelAction = searchCancelAction
        searchBar.clipsToBounds = true
        searchBar.frame = CGRect(
            x: 0,
            y: 0,
            width: view.frame.width,
            height: navigationBarHeight - 2.0 ) // navigation border
        return searchBar
    }()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isImageDataChanged {
            reloadImageData()
            title = rootPageViewController.searchKeyword
            isImageDataChanged.toggle()
        }
    }
    
    // MARK: - Method
    
    func reloadImageData() {
        collectionView.reloadData()
    }
    
    func searchCancelAction() {
        navigationController?.navigationBar.prefersLargeTitles = true
        if titleIsLarged {
            // 8 : largetitle height - navigatio controller height
            collectionView.setContentOffset(CGPoint(x: 0, y: -8), animated: false)
            titleIsLarged = false
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < largeTitleOffsetY {
            titleIsLarged = true
        } else {
            titleIsLarged = false
        }
    }
    
    // MARK: - Private Method
    
    private func setNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.addSubview(navigationSearchBar)
        navigationSearchBar.isHidden = true
    }
    
    private func setCollectionView() {
        collectionView.register(ImageCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // MARK: - objc
    
    @objc private func didTapSearchButton() {
        navigationSearchBar.nowSearching = true
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}

// MARK: - UICollectionViewDataSource

extension ImageCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rootPageViewController.searchedItemList.count
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

// MARK: - UISearchBarDelegate

extension ImageCollectionViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let keyword = searchBar.text {
            title = keyword
        }
        navigationSearchBar.cancelAction()
    }
}
