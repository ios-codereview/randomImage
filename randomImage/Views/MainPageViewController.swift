//
//  MainPageViewController.swift
//  randomImage
//
//  Created by Hyeontae on 03/06/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import UIKit
import RequestBuilder

class MainPageViewController: UIPageViewController {

    // MARK: - Property
    
    private let pageViewControllersType = [StoryBoardType.imageTableView, StoryBoardType.imageCollectionView]

    private lazy var customPageViewControllers = Array<UIViewController?>(repeating: nil, count: self.pageViewControllersType.count)

    private var nowPageIndex = 0
    
    var searchedItemList: [ImageItem] = [] {
        didSet {
            for (index, viewController) in customPageViewControllers.enumerated() where viewController != nil && index != nowPageIndex {
                var notShowingViewController = extractImageSearchController(viewController!)
                notShowingViewController.isImageDataChanged = true
            }
        }
    }
    
    var searchKeyword: String = "" {
        didSet {
            for (index, viewController) in customPageViewControllers.enumerated() {
                if viewController != nil, index == nowPageIndex {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.extractImageSearchController(viewController!).title = self.searchKeyword
                    }
                }
            }
        }
    }
    
    var searchedPageNumber: Int = 1
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPageViewController()
        scrollViewDelegate()
    }
    
    // MARK: - Method
    
    private func setPageViewController() {
        self.dataSource = self
        self.delegate = self
        
        let firstController = pageViewControllersType.first!.initialViewController
        var firstImageSearchController = extractImageSearchController(firstController)
        firstImageSearchController.rootPageViewController = self
        
        customPageViewControllers[0] = firstController
        setViewControllers([firstController], direction: .forward, animated: true, completion: nil)
    }
    
    // 마지막 화면의 바운스를 막기 위한 delegate 설정
    private func scrollViewDelegate() {
        for view in self.view.subviews {
            if let scrollView = view as? UIScrollView {
                scrollView.delegate = self
            }
        }
    }
    
    /// navigationController 의 첫번째 viewController 인 ImageSearchController를 리턴한다.
    ///
    /// - Parameter viewController: ImageSearchController가 포함된 navigation Controller
    /// - Returns: ImageSearchController
    private func extractImageSearchController(_ viewController: UIViewController) -> ImageSearchController {
        if let resourceNavigationController = viewController as? UINavigationController,
            let imageSearchController = resourceNavigationController.viewControllers.first as? ImageSearchController {
            return imageSearchController
        } else {
            fatalError("ImageSearchController must be subController of UINavigationController")
        }
    }
    
    /// keyword 값으로 검색하는 로직
    ///
    /// - Parameter keyword: 검색할 키워드
    func search(_ keyword: String, page number: Int, completion: @escaping (_ list: [ImageItem]?) -> Void) {
        // indicator 추가
        searchKeyword = keyword
        NaverAPI.search.manager.imageItems(keyword: keyword, page: number) { [weak self] (items, error) in
            guard let self = self else { return }
            
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            }
            
            if let items = items {
//                self.searchedItemList.append(contentsOf: items)
                completion(items)
            }
            
            completion(nil)
        }
    }
}

// MARK: - UIPageViewControllerDataSource

extension MainPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let previousIndex = nowPageIndex - 1
        
        if previousIndex >= 0 && customPageViewControllers[previousIndex] == nil {
            let newViewController = pageViewControllersType[previousIndex].initialViewController
            var imageSearchController = extractImageSearchController(newViewController)
            imageSearchController.rootPageViewController = self
            customPageViewControllers[previousIndex] = newViewController
        }
        
        if previousIndex < 0 {
            return nil
        }
        
        return customPageViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let nextIndex = nowPageIndex + 1
        
        if nextIndex < customPageViewControllers.count &&  customPageViewControllers[nextIndex] == nil {
            let newViewController = pageViewControllersType[nextIndex].initialViewController
            var imageSearchController = extractImageSearchController(newViewController)
            imageSearchController.rootPageViewController = self
            customPageViewControllers[nextIndex] = newViewController
        }
        
        if nextIndex >= customPageViewControllers.count {
            return nil
        }
        
        return customPageViewControllers[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate

extension MainPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let nowPageViewController = pageViewController.viewControllers?.first,
            let pageIndex = customPageViewControllers.firstIndex(of: nowPageViewController) else {
                fatalError("nowPageViewController Index Error")
        }
        
        nowPageIndex = pageIndex
    }
}

// MARK: - UIScrollViewDelegate

extension MainPageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if nowPageIndex == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        } else if nowPageIndex == customPageViewControllers.count - 1 && scrollView.contentOffset.x > scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if nowPageIndex == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        } else if nowPageIndex == customPageViewControllers.count - 1 && scrollView.contentOffset.x > scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        }
    }
}
