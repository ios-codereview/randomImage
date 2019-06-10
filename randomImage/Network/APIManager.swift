//
//  APIManager.swift
//  randomImage
//
//  Created by Hyeontae on 01/06/2019.
//  Copyright © 2019 onemoonStudio. All rights reserved.
//

import Foundation
import RequestBuilder

class APIManager {
    
    // MARK: - Property
    
    var apiResource: APIResource {
        didSet {
            urlRequest = RequestBuilder(apiResource: self.apiResource).build()
        }
    }
    
    lazy var urlRequest: URLRequest = {
        return RequestBuilder(apiResource: self.apiResource).build()
    }()
    
    private let urlSession = URLSession(configuration: .default)
    
    // MARK: - Initializer
    
    init(apiResource: APIResource) {
        self.apiResource = apiResource
    }
    
    // MARK: - Instance Method
    
    // error 처리 우아하게 해보자
    func imageItems(keyword: String, completion: @escaping (_ imageData: [ImageItem]?, _ error: Error? ) -> Void ) {
        
        apiResource.query = NaverSearchQuery(query: keyword).queryItems()

        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error)
            }
            
            guard let data = data else {
                print("data is nil")
                completion(nil, nil)
                return
            }
            
            do {
                let responseData = try JSONDecoder().decode(NaverImageSearchResult.self, from: data)
                completion(responseData.items, nil)
            } catch {
                print("decode Error")
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
        
        URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            }
            
            guard let data = data else {
                print("data is nil")
                completion(nil)
                return
            }
            
            completion(data)
            
        }.resume()
    }
 }
