//
//  Repository.swift
//  FlickrAppSearch
//
//  Created by Ahmed Mahdy on 20/09/2021.
//

import Foundation
import RxSwift
import Moya

protocol Repository {
    var provider: MoyaProvider<FlickrTarget> { get }
    var cachingPolicy: CachingPolicy { get }
    func getData<T: Codable>(_ destination: FlickrTarget, decodingType: T.Type) -> Observable<T>
}

extension Repository {
    func getData<T: Codable>(_ destination: FlickrTarget, decodingType: T.Type) -> Observable<T> {
        switch cachingPolicy {
        case .NetworkOnly:
            return .create { observer in
                fetchRemote(destination, decodingType: decodingType).subscribe { (homeresult) in
                    observer.onNext(homeresult)
                } onFailure: { (error) in
                    if let moyaError = error as? MoyaError {
                        let code = moyaError.response?.statusCode
                        let error = FlickrException(code: code, message: moyaError.errorDescription, title: "Error")
                        observer.onError(error)
                    } else {
                        // Error is not moya Error
                    }
                }
            }
        default:
            // will implement loading from cached in future
            return .create { observer in
                Observable.from(optional: decodingType).subscribe { (result) in
                } onError: { (error) in
                }
            }
        }
    }
    
    private func fetchRemote<T: Codable>(_ destination: FlickrTarget, decodingType: T.Type) -> Single<T> {
        return provider.rx                              // we use the Reactive component for our provider
                .request(destination)                         // we specify the call
                .filterSuccessfulStatusAndRedirectCodes()   // we tell it to only complete the call if the operation is successful, otherwise it will give us an error
            .map(decodingType.self)
    }
}
enum CachingPolicy {
    case NetworkIfExist
    case NetworkOnly
    case Offline
}

struct FlickrException: Error {
    let code: Int?
    let message: String?
    let title: String?
    let action: (()->Void)? = nil
}
