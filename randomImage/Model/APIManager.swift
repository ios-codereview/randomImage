//
//  APIManager.swift
//  randomImage
//
//  Created by Hyeontae on 01/06/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import Foundation
import APIResource

class APIManager {
    
    // MARK: - Property
    
    var apiResource: APIResource
    
    lazy var urlRequest: URLRequest = {
        return self.apiResource.urlRequest()
    }()
    
    private let urlSession = URLSession(configuration: .default)
    
    // MARK: - Initializer
    
    init(apiResource: APIResource) {
        self.apiResource = apiResource
    }
    
    // MARK: - Instance Method
    
    func imageItems(keyword: String, page: Int, completion: @escaping (_ imageData: [ImageItem]?, _ error: Error? ) -> Void ) {
        
        apiResource.query = NaverSearchQuery(query: keyword).queryItems(start: page)
        
        urlSession.dataTask(with: urlRequest) { (data, _, error) in
            
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error)
            }
            
            guard let data = data else {
                completion(nil, nil)
                return
            }
            
            do {
                let responseData = try JSONDecoder().decode(NaverImageSearchResult.self, from: data)
                completion(responseData.items, nil)
            } catch {
                completion(nil, error)
            }
            
        }.resume()
        
    }
    
    // MARK: - Static Method
    
    static func downloadImageData(_ urlString: String, completion: @escaping (_ data: Data?) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession(configuration: .default).dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            completion(data)
            
        }.resume()
    }
}
