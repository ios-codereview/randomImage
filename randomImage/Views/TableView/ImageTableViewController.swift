//
//  ImageTableViewController.swift
//  randomImage
//
//  Created by Hyeontae on 07/06/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import UIKit
import RequestBuilder

class ImageTableViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Property
    
    private let cellMargin: CGFloat = 8.0
    private var searchedItemList: [ImageItem] = []
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
    
    // TODO: Test Logic
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sendRequest("Naver")
    }
    
    // MARK: - Method
    
    private func setNavigationBar() {
        // 라지 타이틀을 사용하면 push 되었을 때 그 영역이 같이 넘어간다.
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.title = "TableView"
        navigationItem.searchController = navigationSearchBarController
        // 왜 해주는가? 이 값을 적용함으로서 덮어지는 searchBarContext 를 현재의 viewController에서 관리하게 한다. 만약에 이 값이 false라면 hiararchy를 계속 따라 가면서 결국 uiwindow가 해당 presentation을 관리하게 된다.
        self.definesPresentationContext = true
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(ImageTableViewCell.self), forCellReuseIdentifier: ImageTableViewCell.reuseIdentifier)
    }
    
    private func sendRequest(_ keyword: String) {
        // indicator 추가
        title = keyword
        apiManager.imageItems(keyword: keyword) { [weak self] (items, error) in
            guard let self = self,
                let items = items else {
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("items?")
                    }
                    return
            }
            self.searchedItemList = items
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        let item = searchedItemList[indexPath.row]
        // TODO: NSAttributedString
        let viewFrame = view.frame
        let attrString = NSAttributedString(
            string: item.title,
            attributes: [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0) ])
        let boundingRect = attrString.boundingRect(
            with: CGSize(width: viewFrame.width - 16, height: CGFloat.greatestFiniteMagnitude),
            options: [ NSStringDrawingOptions.usesLineFragmentOrigin ],
            context: nil)
        let imageRatio = CGFloat(Int(item.sizeheight)!) / CGFloat(Int(item.sizewidth)!)
        // TODO: Inset 사용? 확인해보자
        return ( ceil(boundingRect.height) + ( 2 * cellMargin ) ) + ( imageRatio * viewFrame.width ) + cellMargin
    }
}

// MARK: - UITableViewDataSource

extension ImageTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 여기서 값을 늘리면 되나? 아니면 다른 것을 사용해야 할까?
        return searchedItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.reuseIdentifier) as? ImageTableViewCell else {
            return UITableViewCell()
        }
        let individualItem = searchedItemList[indexPath.row]
        cell.configure(individualItem.title)
        DispatchQueue.global().async {
            CacheImageManager.image(urlString: individualItem.link, completion: { (image) in
                guard let image = image else { return }
                DispatchQueue.main.async {
                    cell.configure(image)
                }
            })
//            self.apiManager.downloadImage(individualItem.link) { (image) in
//                guard let image = image else { return }
//                DispatchQueue.main.async {
//                    cell.configure(image)
//                }
//            }
        }
        return cell
    }

}

// MARK: - UITableViewDelegate

extension ImageTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight(indexPath)
    }
}

// MARK: - UISearchControllerDelegate

extension ImageTableViewController: UISearchControllerDelegate {
    
}

// MARK: - UISearchBarDelegate

extension ImageTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchedText = searchBar.text {
            sendRequest(searchedText)
            // 중간에 검색된 경우 취소하는 로직이 있어야 할듯?
        }
        searchBar.text = nil
        navigationSearchBarController.isActive = false
    }
}
