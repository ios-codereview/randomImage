//
//  CacheImageManager.swift
//  randomImage
//
//  Created by Hyeontae on 09/06/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import UIKit

fileprivate let imageCache = NSCache<NSString, UIImage>()

class CacheImageManager {
    
    static func image(urlString: String, completion: @escaping (_ image: UIImage?)  -> Void ) {
        
        // if image already cached
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            completion(cachedImage)
            return
        }
        
        // OR download Image with Network
        APIManager.downloadImage(urlString) { (image) in
            guard let image = image else {
                completion(nil)
                return
            }
            
            imageCache.setObject(image, forKey: urlString as NSString)
            completion(image)
            return
        }
    }
}
