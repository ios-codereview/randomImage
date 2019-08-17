//
//  CacheImageManager.swift
//  randomImage
//
//  Created by Hyeontae on 09/06/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import UIKit

private let imageCache = NSCache<NSString, UIImage>()
private let imageDataCache = NSCache<NSString, NSData>()

class CacheImageManager {
    
    static let downsampledImageQueue = DispatchQueue(label: "downsampledImage", qos: .unspecified, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
    
    /// 원본 이미지
    static func image(urlString: String, completion: @escaping (_ image: UIImage?) -> Void ) {
        // Review: [Refactoring] Cache와 API에서 Image를 가져오는 것은 Repository 패턴을 사용하는건 어떨까요?
        // https://miro.medium.com/max/1400/1*UDzzNYwInvHg25V_OtWejg.jpeg
        // if image already cached
        if let cachedImageData = imageDataCache.object(forKey: urlString as NSString),
            let image = UIImage(data: cachedImageData as Data) {
            completion(image)
            return
        }
        
        // OR download Image with Network
        APIManager.downloadImageData(urlString) { (data) in
            guard let data: Data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            imageDataCache.setObject(data as NSData, forKey: urlString as NSString)
            completion(image)
            return
        }
    }
    
    /// 다운샘플링한 이미지 이미 실행된 Task 들을 위해서 중간 중간에 이미지 cancel 로직을 넣었다.
    static func downSampledImage(
        urlString: String,
        viewSize: CGSize,
        imageWorkItem: DispatchWorkItem,
        completion: @escaping (_ image: UIImage?) -> Void
    ) {
        if let cachedData = imageDataCache.object(forKey: urlString as NSString) {
            completion(downSampling(image: cachedData, to: viewSize, scale: UIScreen.main.scale, imageWorkItem: imageWorkItem))
            return
        }
        
        APIManager.downloadImageData(urlString) { (data) in
            //            Review: [Refactroing] 같은 작업이 이미 실행 중인지 검사도 필요하지 않을까요?
            guard let data: Data = data, !imageWorkItem.isCancelled else {
                completion(nil)
                return
            }
            let imageNSData = NSData(data: data)
            imageDataCache.setObject(imageNSData, forKey: urlString as NSString)
            completion(downSampling(image: imageNSData, to: viewSize, scale: UIScreen.main.scale, imageWorkItem: imageWorkItem))
        }
    }
    
    /// 이미지 다운 샘플링
    static func downSampling(
        image data: NSData,
        to pointSize: CGSize,
        scale: CGFloat,
        imageWorkItem: DispatchWorkItem) -> UIImage?
    {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, imageSourceOptions) else { fatalError("cannot create imageSource") }
        
        if imageWorkItem.isCancelled {
            return nil
        }
        
        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
        let downsampleOptions =  [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels] as CFDictionary
        
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
            return nil
        }
        return UIImage(cgImage: downsampledImage)
    }
}
