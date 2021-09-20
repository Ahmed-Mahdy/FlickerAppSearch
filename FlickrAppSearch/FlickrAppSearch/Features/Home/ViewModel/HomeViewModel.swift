//
//  HomeViewModel.swift
//  FlickrAppSearch
//
//  Created by Ahmed Mahdy on 20/09/2021.
//

import Foundation
import RxSwift
import Moya

class HomeViewModel: BaseViewModel {
    
    var isLoading: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    public let photos : PublishSubject<[Photo]> = PublishSubject()
    public let lastSearchTerms: PublishSubject<[String]> = PublishSubject()
    var isError: PublishSubject<Error> = PublishSubject()
    var disposeBag: DisposeBag = DisposeBag()
    private var repository: FlickrSearchRepository
    
    private let dataManager = coreDataManager()
    private var keyword = ""
    private var pageNumber = 1
    private var totalPages = 1
    private(set) var photoArray = [Photo]()
    
    init (_ repo: FlickrSearchRepository = FlickrSearchRepository()) {
        repository = repo
    }
    func search(with text: String) {
        keyword = text
        photoArray.removeAll()
        fetch()
    }
    func fetch() {
        self.isLoading.onNext(true)
        let observable = repository.search(keyword: keyword, page: pageNumber)
        getData(observable, decodingType: FlickrSearchResults.self).observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                guard let self = self else { return }
                if result.stat.uppercased().contains("OK") {
                    self.photoArray += result.photos.photo
                    self.totalPages = result.photos.pages
                    self.photos.onNext(self.photoArray)
                }
            } onError: {_ in
            }.disposed(by: disposeBag)
    }
    func loadNextPage() {
        if pageNumber < totalPages {
            pageNumber += 1
            fetch()
        }
    }

    func getLastSearchTerms() {
        lastSearchTerms.onNext(dataManager.getLastSearchTerms())
    }

    func saveSearchTerm(name: String){
        dataManager.save(name: name)
    }
}

