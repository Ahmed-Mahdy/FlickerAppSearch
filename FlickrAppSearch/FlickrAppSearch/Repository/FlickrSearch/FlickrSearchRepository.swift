//
//  FlickrSearchRepository.swift
//  FlickrAppSearch
//
//  Created by Ahmed Mahdy on 20/09/2021.
//

import Foundation
import RxSwift
import Moya

class FlickrSearchRepository: Repository {
    var cachingPolicy: CachingPolicy
    var provider = MoyaProvider<FlickrTarget>(plugins: [ NetworkLoggerPlugin() ])
    
    public init(cachingPolicy: CachingPolicy = .NetworkOnly) {
        self.cachingPolicy = cachingPolicy
    }
    func search(keyword: String, page: Int) -> Observable<FlickrSearchResults> {
        return getData(.search(keyword: keyword, page: page), decodingType: FlickrSearchResults.self)
    }
}
