//
//  ImageTableViewController.swift
//  randomImage
//
//  Created by Hyeontae on 07/06/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import UIKit

class ImageTableViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Property
    
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
    }
    
}

// MARK: - UITableViewDataSource

extension ImageTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

// MARK: - UITableViewDelegate

extension ImageTableViewController: UITableViewDelegate {
    
}

extension ImageTableViewController: UISearchControllerDelegate {
    
}

extension ImageTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchedText = searchBar.text {
            title = searchedText
        }
        searchBar.text = nil
        navigationSearchBarController.isActive = false
        
    }
}
