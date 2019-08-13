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
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.maximumZoomScale = 3.0
            scrollView.minimumZoomScale = 1.0
        }
    }
    
    // MARK: - Property
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var image: UIImage?
    
    lazy var imageView: UIImageView = {
        let resultImageView = UIImageView()
        resultImageView.image = image
        resultImageView.contentMode = .scaleAspectFit
        resultImageView.frame = imageFrame
        resultImageView.isUserInteractionEnabled = true
        return resultImageView
    }()
    
    lazy var imageFrame: CGRect = {
        guard let imageSize = image?.size else { fatalError("image is nil") }
        let imageRatio = imageSize.width / imageSize.height
        if imageRatio >= 1 {
            // 가로가 더 긴 경우
            let imageHeight = view.frame.width / imageRatio
            return CGRect(
                x: 0,
                y: ( view.frame.height - imageHeight ) / 2,
                width: view.frame.width,
                height: imageHeight)
        } else {
            // 세로가 더 긴 경우
            let imageWidth = view.frame.height * imageRatio
            return CGRect(
                x: ( view.frame.width - imageWidth ) / 2,
                y: 0,
                width: imageWidth,
                height: view.frame.height)
        }
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setImageView()
    }
    
    private func setImageView() {
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
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let scale = scrollView.zoomScale
        var newImageOrigin: CGPoint {
            if scale <= 1.0 || imageView.frame.height >= view.frame.height {
                return imageView.frame.origin
            }
            let yOffset = (imageView.frame.height - imageFrame.size.height) / 2
            return CGPoint(x: 0, y: imageFrame.origin.y - yOffset)
        }
        
        imageView.frame.origin = newImageOrigin
    }
}
