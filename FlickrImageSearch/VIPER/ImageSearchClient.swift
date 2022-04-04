//
//  ImageSearchClient.swift
//  ImageSearchClient
//
//  Created by Virendra Ravalji on 03/04/22.
//

import Foundation

final class ImageSearchClient {
    private lazy var baseURL: URL = {
        return URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=2932ade8b209152a7cbb49b631c4f9b6&%20format=json&nojsoncallback=1&safe_search=1")!
    }()
    
    let urlString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=2932ade8b209152a7cbb49b631c4f9b6&%20format=json&nojsoncallback=1&safe_search=1"
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
//    func fetchModerators(with request: ModeratorRequest, page: Int, completion: @escaping (Result<PagedModeratorResponse, DataResponseError>) -> Void) {
//        let urlRequest = URLRequest(url: baseURL.appendingPathComponent(request.path))
//        let parameters = ["page": "\(page)"].merging(request.parameters, uniquingKeysWith: +)
//        let encodedURLRequest = urlRequest.encode(with: parameters)
//        
//        session.dataTask(with: encodedURLRequest, completionHandler: { data, response, error in
//            // 4
//            guard
//                let httpResponse = response as? HTTPURLResponse,
//                httpResponse.hasSuccessStatusCode,
//                let data = data
//            else {
//                completion(Result.failure(DataResponseError.network))
//                return
//            }
//            
//            guard let decodedResponse = try? JSONDecoder().decode(PagedModeratorResponse.self, from: data) else {
//                completion(Result.failure(DataResponseError.decoding))
//                return
//            }
//            
//            completion(Result.success(decodedResponse))
//        }).resume()
//    }
    
    func sendRequest(_ url: String?, parameters: [String: String], completion: @escaping (Response?, DataResponseError?) -> Void) {
        var components = URLComponents(string: urlString)!
        
        let defaultParameters = ["method": "flickr.photos.search", "api_key": "2932ade8b209152a7cbb49b631c4f9b6", "format": "json", "nojsoncallback": "1","safe_search": "1"]
        let parameters = parameters.merging(defaultParameters, uniquingKeysWith: +)
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: components.url!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,                              // is there data
                let response = response as? HTTPURLResponse,  // is there HTTP response
                200 ..< 300 ~= response.statusCode,           // is statusCode 2XX
                error == nil                                  // was there no error
            else {
                completion(nil, .network)
                return
            }
            
            let responseObject = try? JSONDecoder().decode(Response.self, from: data)
            completion(responseObject, nil)
        }
        task.resume()
    }
}

enum DataResponseError: Error {
  case network
  case decoding
  
  var reason: String {
    switch self {
    case .network:
      return "An error occurred while fetching data"
    case .decoding:
      return "An error occurred while decoding data"
    }
  }
}
