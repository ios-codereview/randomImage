//
//  MainPageViewController.swift
//  randomImage
//
//  Created by Hyeontae on 03/06/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import UIKit

class MainPageViewController: UIPageViewController {

    // MARK: - Property
    
    private lazy var customPageViewControllers: [UIViewController] = {
        return [StoryBoardType.imageTableView.initialViewController , StoryBoardType.imageCollectionView.initialViewController]
    }()
    private var nowPageIndex = 0
    
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
        guard let firstViewController = customPageViewControllers.first else { fatalError("first View Controller Error") }
        setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
    }
    
    private func scrollViewDelegate() {
        for view in self.view.subviews {
            if let scrollView = view as? UIScrollView {
                scrollView.delegate = self
            }
        }
    }
    
}

// MARK: - UIPageViewControllerDataSource

extension MainPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = customPageViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        if previousIndex < 0 {
            return nil
        }
        return customPageViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = customPageViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
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
