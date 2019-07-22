//
//  ImageTableViewController.swift
//  randomImage
//
//  Created by Hyeontae on 07/06/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import UIKit

class ImageTableViewController: UIViewController, ImageSearch {

    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIBarButtonItem! {
        didSet {
            searchButton.target = self
            searchButton.action = #selector(didTapSearchButton)
        }
    }
    
    // MARK: - Property
    
    weak var rootPageViewController: MainPageViewController!
    // Data
    var isImageDataChanged: Bool = false
    var isNowSearching: Bool = false
    private var newSearch = false
    private var pageNumber: Int = 1
    // Layout
    private let largeTitleOffsetY: CGFloat = 6.0
    private var titleIsLarged = false
    private let cellMargin: CGFloat = 8.0
    private let cellSeperatorHeight: CGFloat = 10.0
    
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
        setTableView()
        setDefaultSearch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isImageDataChanged {
            reloadImageData()
            navigationItem.title = rootPageViewController.searchKeyword
            isImageDataChanged.toggle()
        }
    }
    
    // MARK: - Method
    
    // 첫번째 섹션만 데이터를 표현하므로 해당 섹션만 reload 한다.
    func reloadImageData() {
        UIView.performWithoutAnimation {
            tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
    
    // 검색하다가 cancel을 누른 경우 사용되는 함수
    func searchCancelAction() {
        navigationController?.navigationBar.prefersLargeTitles = true
        if titleIsLarged {
            // 8 : largetitle height - navigatio controller height
            tableView.setContentOffset(CGPoint(x: 0, y: -8), animated: false)
            titleIsLarged = false
        }
    }
    
    // 현재 LargeTitle 로 되어있는지 판단한다. navigation Search bar를 위해서 titleIsLarge 를 이용
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < largeTitleOffsetY {
            titleIsLarged = true
        } else {
            titleIsLarged = false
        }
    }
    
    // MARK: - Private Method
   
    /// Large Title 관련된 Navigation View Controller를 설정해준다.
    private func setNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.addSubview(navigationSearchBar)
        navigationSearchBar.isHidden = true
    }
    
    /// 테이블뷰 설정
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.registerReusableCell(ImageTableViewCell.self)
        tableView.registerReusableCell(LoadingCell.self)
    }
    
    // 초기에 데이터가 없는 경우 default로 검색하는 함수
    private func setDefaultSearch() {
        isNowSearching = true
        if rootPageViewController.searchedItemList.isEmpty {
            search("Naver", page: pageNumber)
        }
    }
    
    /// 각각의 셀의 높이를 계산하기 위한 로직
    private func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            let item = rootPageViewController.searchedItemList[indexPath.row]
            let viewFrameSize = view.frame.size
            let attrString = NSAttributedString(
                string: item.title,
                attributes: [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0) ])
            let boundingRect = attrString.boundingRect(
                with: CGSize(width: viewFrameSize.width - 16, height: CGFloat.greatestFiniteMagnitude),
                options: [ NSStringDrawingOptions.usesLineFragmentOrigin ],
                context: nil)
            // TODO: Inset 사용? 확인해보자
            return ( ceil(boundingRect.height) + ( 2 * cellMargin ) ) + imageViewSize(item, viewFrameSize).height + cellSeperatorHeight
        } else {
            return 44.0
        }
    }
    
    /// 이미지뷰의 사이즈를 계산하기 위한 로직
    private func imageViewSize(_ info: ImageItem,_ viewFrameSize: CGSize) -> CGSize {
        let viewFrameWidth = viewFrameSize.width
        let imageRatio = CGFloat(Int(info.sizeheight)!) / CGFloat(Int(info.sizewidth)!)
        var resultHeight: CGFloat {
            let imageHeightMultipliedByRatio = ( imageRatio * viewFrameWidth )
            let halfHeightOfView = viewFrameSize.height / 2.0
            if imageHeightMultipliedByRatio > halfHeightOfView {
                return halfHeightOfView
            } else {
                return imageHeightMultipliedByRatio
            }
        }
        return CGSize(width: viewFrameWidth, height: resultHeight)
    }
    
    // search
    private func search(_ keyword: String, page number: Int) {
        rootPageViewController.search(keyword, page: number) { items in
            guard let items = items else { return }
            let base = (self.pageNumber-1) * 20
            let newIndexPaths = items.enumerated().map { IndexPath(row: base + $0.offset, section: 0) }
            
            DispatchQueue.main.async {
                self.tableView.beginUpdates()
                
                if self.newSearch {
                    let deleted = self.rootPageViewController.searchedItemList.enumerated().map { IndexPath(row: $0.offset, section: 0) }
                    self.tableView.deleteRows(at: deleted, with: .none)
                    self.rootPageViewController.searchedItemList.removeAll()
                    self.navigationController?.navigationBar.prefersLargeTitles = true
                    self.newSearch = false
                }
                
                self.rootPageViewController.searchedItemList.append(contentsOf: items)
                self.tableView.insertRows(at: newIndexPaths, with: .none)
                self.isNowSearching = false
                self.tableView.endUpdates()
            }
        }
    }
    
    /// 요청이 더 필요한 경우
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

// MARK: - UITableViewDataSource

extension ImageTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return rootPageViewController.searchedItemList.count
        } else {
            return 1
        }
    }
    
    /// 다운샘플링 된 이미지가 cell 에 뿌려진다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.reuseIdentifier) as? ImageTableViewCell else {
                return UITableViewCell()
            }
            let individualItem = rootPageViewController.searchedItemList[indexPath.row]
            let viewFrameSize = view.frame.size
            cell.configure(individualItem.title)
            
            // cancel 처리 ...?
            var imageTask: DispatchWorkItem!
            imageTask = DispatchWorkItem {
                CacheImageManager.downSampledImageTask(
                    urlString: individualItem.link,
                    viewSize: self.imageViewSize(individualItem, viewFrameSize),
                    imageWorkItem: imageTask,
                    completion: { image in
                        guard let image = image, !imageTask.isCancelled else { return }
                        DispatchQueue.main.async {
                            cell.configure(image)
                        }
                })
            }
            cell.imageWorkItem = imageTask
            CacheImageManager.downsampledImageQueue.sync(execute: imageTask)
            
            // 아래는 다운샘플링 이미지 작업 처리
//            DispatchQueue.global().async { [weak self] in
//                guard let self = self else { return }
//                CacheImageManager.downSampledImage(urlString: individualItem.link, viewSize: self.imageViewSize(individualItem, viewFrameSize), completion: { (image, url) in
//                        guard let image = image else { return }
//                        DispatchQueue.main.async {
//                            if url == self.rootPageViewController.searchedItemList[indexPath.row].link {
//                                cell.configure(image)
//                            }
//                        }
//                })
//            }
            
            return cell
            
        } else {
            // Loading Cell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LoadingCell.reuseIdentifier) as? LoadingCell else {
                return UITableViewCell()
            }
            cell.loadingIndicator.startAnimating()
            return cell
        }
    }
    
}

// MARK: - UITableViewDelegate

extension ImageTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight(indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

// MARK: - UITableViewDataSourcePrefetching

extension ImageTableViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        print(indexPaths)
        for indexPath in indexPaths where indexPath.section == 1 && !isNowSearching {
            isNowSearching.toggle()
            loadMoreImages()
        }
    }
}

// MARK: - UISearchBarDelegate

extension ImageTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchedText = searchBar.text {
            pageNumber = 1
            newSearch = true
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            search(searchedText, page: pageNumber)
        }
        searchBar.text = nil
        navigationSearchBar.cancelAction()
    }
}
