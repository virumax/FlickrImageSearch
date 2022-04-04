//
//  ImageSearchClient.swift
//  ImageSearchClient
//
//  Created by Virendra Ravalji on 03/04/22.
//

import Foundation

final class ImageSearchClient {
    let urlString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=2932ade8b209152a7cbb49b631c4f9b6&%20format=json&nojsoncallback=1&safe_search=1"
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func sendRequest(parameters: [String: String], page: Int, completion: @escaping (Response?, DataResponseError?) -> Void) {
        var components = URLComponents(string: urlString)!
        
        let defaultParameters = ["method": "flickr.photos.search", "api_key": "2932ade8b209152a7cbb49b631c4f9b6", "format": "json", "nojsoncallback": "1","safe_search": "1", "page": "\(page)"]
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
            
            if let responseObject = try? JSONDecoder().decode(Response.self, from: data) {
                if responseObject.photos.photo.count == 0 {
                    completion(nil, .nodata)
                } else {
                    completion(responseObject, nil)
                }
            } else {
                completion(nil, .network)
            }
        }
        task.resume()
    }
}

enum DataResponseError: Error {
    case network
    case nodata
    
    var reason: String {
        switch self {
        case .network:
            return localizedString(forKey: StringConstants.networkError)
        case .nodata:
            return localizedString(forKey: StringConstants.noDataError)
        }
    }
}
