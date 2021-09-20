//
//  FlickrTarget.swift
//  FlickrAppSearch
//
//  Created by Ahmed Mahdy on 20/09/2021.
//

import Foundation
import Moya

enum FlickrTarget {
    static private var apiKey = "11c40ef31e4961acf4f98c8ff4e945d7"
    static let perPage = 60
    static let imageURL = "https://farm%d.staticflickr.com/%@/%@_%@.jpg"
    case search(keyword: String, page: Int)
}

extension FlickrTarget: TargetType {
    
    
    var baseURL: URL {
        return URL(string: "https://api.flickr.com/services/rest/")!
    }
    
    var path: String {
        switch self {
        case .search:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .search:
            return .get
        }
    }
    
    public var sampleData: Data {
        if let path = Bundle.main.path(forResource: "ImageResultMock", ofType: "json") {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
              } catch {
                   // handle error
                return Data()
              }
        }
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .search(let keyword, let page):
            var urlParams = [String:Any]()
            urlParams = [
                "method": "flickr.photos.search",
                "api_key": FlickrTarget.apiKey,
                "format": "json",
                "nojsoncallback": "1",
                "safe_search": "1",
                "per_page": FlickrTarget.perPage,
                "text": keyword,
                "page": page
            ]
            return .requestParameters(parameters: urlParams, encoding: URLEncoding.queryString)
        }
    }
    
    public var headers: [String: String]? {
        return nil
    }
    
}
