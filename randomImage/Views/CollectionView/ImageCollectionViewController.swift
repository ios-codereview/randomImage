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
    var isImageDataChanged: Bool = true
    private let insetsForSections = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    private let minimumSpacingForRow: CGFloat = 5.0
    private let widthBetweenItems: CGFloat = 5.0
    private let itemsPerRow: CGFloat = 2.0
    private let largeTitleOffsetY: CGFloat = 6.0
    private var titleIsLarged = false
    private var isNowSearching = false
    private var newSearch = false
    // TODO: 이 pageNumber는 root에 있는게 더 좋을 듯
    private var pageNumber = 1
    private lazy var collectionViewCellSize: CGSize = {
        let paddingSpace = (itemsPerRow + 1) * insetsForSections.left
        let widthPerItem = (collectionView.bounds.width - paddingSpace) / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }()
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
            navigationItem.title = rootPageViewController.searchKeyword
            isImageDataChanged = false
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
        collectionView.register(LoadingCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func imageViewSize(_ cell: ImageCollectionViewCell) -> CGSize {
        let labelHeight = cell.imageTitle.frame.height
        let offsetFromLabel: CGFloat = 8.0
        return CGSize(width: collectionViewCellSize.width, height: collectionViewCellSize.height - labelHeight - offsetFromLabel)
    }
    
    private func search(_ keyword: String, page number: Int) {
        rootPageViewController.search(keyword, page: number) { items in
            guard let items = items else { return }
            let base = (self.pageNumber-1) * 20
            let newIndexPaths = items.enumerated().map { IndexPath(row: base + $0.offset, section: 0) }
            // 아이템 추가
            DispatchQueue.main.async {
                
                if self.newSearch {
                    let deleted = self.rootPageViewController.searchedItemList.enumerated().map { IndexPath(row: $0.offset, section: 0) }
                    self.rootPageViewController.searchedItemList.removeAll()
                    self.collectionView.deleteItems(at: deleted)
                    self.navigationController?.navigationBar.prefersLargeTitles = true
                    self.newSearch = false
                }

                self.rootPageViewController.searchedItemList.append(contentsOf: items)
                self.collectionView.insertItems(at: newIndexPaths)
                self.isNowSearching = false
            }
        }
    }
    
    private func loadMoreImages() {
        pageNumber += 1
        search(rootPageViewController.searchKeyword, page: pageNumber)
    }
    
    // MARK: - objc
    
    @objc private func didTapSearchButton() {
        navigationSearchBar.nowSearching = true
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
}

// MARK: - UICollectionViewDataSource

extension ImageCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return rootPageViewController.searchedItemList.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell
                else {fatalError("collectionView cell is not ImageCollectionViewCell")}
            let individualItem = rootPageViewController.searchedItemList[indexPath.row]
            cell.configure(individualItem.title)
            CacheImageManager.downSampledImage(
                urlString: individualItem.link,
                viewSize: self.imageViewSize(cell),
                completion: { (image, url) in
                    guard let image = image else { return }
                    DispatchQueue.main.async {
                        if url == self.rootPageViewController.searchedItemList[indexPath.row].link {
                            cell.confifure(image)
                        }
                    }
            })
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCollectionViewCell.reuseIdentifier, for: indexPath) as? LoadingCollectionViewCell
                else { fatalError(" dequeue LoadingCollectionViewCell Error") }
            
            if !isNowSearching {
                isNowSearching = true
                cell.loadingIndicator.startAnimating()
                if collectionView.contentOffset.y != 0 {
                    Timer.scheduledTimer(withTimeInterval: TimeInterval(1.0), repeats: false) { (_) in
                        self.loadMoreImages()
                        cell.loadingIndicator.stopAnimating()
                    }
                }
            }

            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ImageCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return collectionViewCellSize
        } else {
            return CGSize(width: collectionView.frame.width, height: 54.0)
        }
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let individualItem = rootPageViewController.searchedItemList[indexPath.row]
        CacheImageManager.image(urlString: individualItem.link, completion: {
            guard
                let image = $0,
                let detailViewController = StoryBoardType.imageDetailView.initialViewController as? DetailViewController
                else { fatalError("detail view error") }
            detailViewController.image = image
            self.present(detailViewController, animated: true, completion: nil)
        })
    }
}

// MARK: - UISearchBarDelegate

extension ImageCollectionViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let keyword = searchBar.text {
            title = keyword
            newSearch = true
            search(keyword, page: pageNumber)
        }
        searchBar.text = nil
        navigationSearchBar.cancelAction()
    }
}
