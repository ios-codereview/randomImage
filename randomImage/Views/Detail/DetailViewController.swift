//
//  DetailViewController.swift
//  randomImage
//
//  Created by Hyeontae on 04/07/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - IBOutlet

    @IBOutlet weak var closeButton: UIButton! {
        didSet {
            closeButton.addTarget(self, action: #selector(closeImageDetail), for: .touchUpInside)
        }
    }
    
    // MARK: - Property
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var image: UIImage?
    
    lazy var scrollView: UIScrollView = {
        let imageSize = image!.size
        let viewFrame = view.frame
        let scrollViewHight = imageSize.height / imageSize.width * viewFrame.width
//        let newScrollView = UIScrollView(frame: CGRect(x: 0, y: (viewFrame.height - scrollViewHight) / 2.0 , width: viewFrame.width, height: scrollViewHight))
        let newScrollView = UIScrollView(frame: CGRect(x: 0, y: 0 , width: viewFrame.width, height: viewFrame.height))
        newScrollView.delegate = self
        newScrollView.maximumZoomScale = 3.0
        newScrollView.minimumZoomScale = 1.0
//        newScrollView.isUserInteractionEnabled = true
        return newScrollView
    }()
    
    lazy var imageView: UIImageView = {
        let resultImageView = UIImageView()
        resultImageView.image = image
        resultImageView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        resultImageView.contentMode = .scaleAspectFit
//        resultImageView.translatesAutoresizingMaskIntoConstraints = false
//        resultImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0.0)
//        resultImageView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0.0)
//        resultImageView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: 0.0)
//        resultImageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0.0)
        resultImageView.isUserInteractionEnabled = true
        return resultImageView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setScrollView()
        
        // Do any additional setup after loading the view.
    }
    
    private func setScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
    }
    
    // MARK: - objc
    @objc private func closeImageDetail(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension DetailViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print(scale)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("frame - > \(imageView.frame)")
        print("bound - > \(imageView.bounds)")
    }
}
