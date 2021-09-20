//
//  BaseViewModel.swift
//  FlickrAppSearch
//
//  Created by Ahmed Mahdy on 20/09/2021.
//

import Foundation
import RxSwift

protocol BaseViewModel {
    var isLoading: BehaviorSubject<Bool> { get }
    var isError: PublishSubject<Error> { get }
    var disposeBag: DisposeBag { get }
}
extension BaseViewModel {
    func configureDisposeBag() {
        isError.disposed(by: disposeBag)
        isLoading.disposed(by: disposeBag)
    }
    func getData<T: Codable>(_ observable: Observable<T>, decodingType: T.Type, genericErrors: Bool = true, withLoading: Bool = true) -> Observable<T> {
        return .create { (observer) in
            observable.subscribe { (homeresult) in
                if withLoading {
                    self.isLoading.onNext(false)
                }
                observer.onNext(homeresult)
            } onError: { (error) in
                self.isLoading.onNext(false)
                if genericErrors {
                    self.isError.onNext(error)
                }
                observer.onError(error)
            }
        }
    }
}
