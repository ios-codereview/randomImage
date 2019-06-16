//
//  ImageTableViewController.swift
//  randomImage
//
//  Created by Hyeontae on 07/06/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import UIKit
import RequestBuilder

class ImageTableViewController: UIViewController, ImageSearch {

    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Property
    
//    var searchedItemList: [ImageItem] = []
    weak var rootPageViewController: MainPageViewController!
    var isImageDataChanged: Bool = false
    
    private let cellMargin: CGFloat = 8.0
    private let cellSeperatorHeight: CGFloat = 10.0
    private var numberOfImagePerPage: Int = 20
    private var pageNumber: Int = 1
    private lazy var searchAPI: APIResource = {
        var api = ImageSearchRequestAPI(urlString: "https://openapi.naver.com/v1/search/image")
        api.headers = [SecretKey.id.key: SecretKey.id.value, SecretKey.secret.key: SecretKey.secret.value]
        return api
    }()
    private lazy var apiManager: APIManager = {
        let manager = APIManager(apiResource: self.searchAPI)
        return manager
    }()
    private lazy var navigationSearchBarController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isImageDataChanged {
            reloadImageData()
            title = rootPageViewController.searchKeyword
            isImageDataChanged.toggle()
        }
    }
    
    // TODO: Test Logic -> Search Naver
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sendRequest("Naver", page: pageNumber)
    }
    
    // MARK: - Method
    
    func reloadImageData() {
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    /// Large Title 관련된 Navigation View Controller를 설정해준다.
    private func setNavigationBar() {
        // 라지 타이틀을 사용하면 push 되었을 때 그 영역이 같이 넘어간다?!
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.title = "TableView"
        navigationItem.searchController = navigationSearchBarController
        // 왜 해주는가? 이 값을 적용함으로서 덮어지는 searchBarContext 를 현재의 viewController에서 관리하게 한다. 만약에 이 값이 false라면 hiararchy를 계속 따라 가면서 결국 uiwindow가 해당 presentation을 관리하게 된다.
        self.definesPresentationContext = true
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    /// keyword 값으로 검색하는 로직
    ///
    /// - Parameter keyword: 검색할 키워드
    private func sendRequest(_ keyword: String, page number: Int) {
        // indicator 추가
        rootPageViewController.searchKeyword = keyword
        apiManager.imageItems(keyword: keyword, page: number) { [weak self] (items, error) in
            guard let self = self,
                let items = items else {
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("items?")
                    }
                    return
            }
            self.rootPageViewController.searchedItemList.append(contentsOf: items)
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
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
    
    /// 요청이 더 필요한 경우
    private func loadMoreImages() {
        guard let nowTitle = title else { return }
        pageNumber += 1
        sendRequest(nowTitle, page: pageNumber)
        
    }
    
    private func debug(index: IndexPath) {
        print("\(index) => \(rootPageViewController.searchedItemList[index.row].title)")
    }
}

// MARK: - UITableViewDataSource

extension ImageTableViewController: UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return rootPageViewController.searchedItemList.count
        } else if section == 1 {
            return 1
        }
        return 0
    }
    
    /// 다운샘플링 된 이미지가 cell 에 뿌려진다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.reuseIdentifier) as? ImageTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            let individualItem = rootPageViewController.searchedItemList[indexPath.row]
            let viewFrameSize = view.frame.size
            cell.configure(individualItem.title)
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                CacheImageManager.downSampledImage(
                    urlString: individualItem.link,
                    viewSize: self.imageViewSize(individualItem, viewFrameSize),
                    scale: UIScreen.main.scale,
                    completion: { (image) in
                        guard let image = image else { return }
                        DispatchQueue.main.async {
                            cell.configure(image)
                        }
                })
            }
            return cell
            
        } else {
            // Loading
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LoadingCell.reuseIdentifier) as? LoadingCell else {
                return UITableViewCell()
            }
            cell.loadingIndicator.startAnimating()
            if tableView.contentOffset.y != 0 {
                Timer.scheduledTimer(withTimeInterval: TimeInterval(1.0), repeats: false) { (_) in
                    self.loadMoreImages()
                    cell.loadingIndicator.stopAnimating()
                }
            }
            return cell
        }
    }
    
    private func debug() {
        for (index, item) in rootPageViewController.searchedItemList.enumerated() {
            print("\(index) =>  \(item.title)")
        }
    }

}

// MARK: - UITableViewDelegate

extension ImageTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight(indexPath)
    }
}

// MARK: - UITableViewDataSourcePrefetching

extension ImageTableViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        // loading을 보여줄 것이라면 prefetch에서 할 필요가 없다.
//        for indexPath in indexPaths {
//            if tableView.contentOffset.y != 0 && indexPath.section != 0 {
//                Timer.scheduledTimer(withTimeInterval: TimeInterval(1.0), repeats: false) { (_) in
//                    self.loadMoreImages()
//                }
//            }
//        }
        // Infinite Scroll
//        let totalImages = pageNumber * numberOfImagePerPage
//        for indexPath in indexPaths {
//            if tableView.contentOffset.y != 0 && indexPath.row == totalImages - 1 {
//                loadMoreImages()
//            }
//        }
    }
}

// MARK: - UISearchControllerDelegate

extension ImageTableViewController: UISearchControllerDelegate {
    
}

// MARK: - UISearchBarDelegate

extension ImageTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchedText = searchBar.text {
            pageNumber = 1
            rootPageViewController.searchedItemList.removeAll()
            sendRequest(searchedText, page: pageNumber)
            // 중간에 검색된 경우 취소하는 로직이 있어야 할듯?
        }
        searchBar.text = nil
        navigationSearchBarController.isActive = false
    }
}
