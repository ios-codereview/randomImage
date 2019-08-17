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
    
    // Review: [Refactoring] 유연하게 API를 호출 할 수 있도록 URLRequest 를 Parameter로 전달하는건 어떨까요?
//    func imageItems(request: URLRequest, completion: @escaping (_ imageData: [ImageItem]?, _ error: Error? ) -> Void )
    
    // Review: [Refacroing] Result<[ImageItem], Error> 를 사용하는건 어떨까요?
//    func imageItems(keyword: String, page: Int, completion: @escaping (Result<[ImageItem], Error>) -> Void )
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
        // Review: [Refactoring] 이미지 다운로드는 ephemeral 옵션으로 생성하는건 어떨까요?
        // 캐시, 쿠키 또는 자격 증명에 영구 저장소를 사용하지 않는 세션 구성입니다.
        // https://github.com/onevcat/Kingfisher/blob/master/Sources/Networking/ImageDownloader.swift
        // Kingfisher ImageDownloader 참고
        URLSession(configuration: .ephemeral).dataTask(with: url) { (data, _, error) in
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
