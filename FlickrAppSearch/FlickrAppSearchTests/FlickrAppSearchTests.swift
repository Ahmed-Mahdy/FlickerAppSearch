//
//  FlickrAppSearchTests.swift
//  FlickrAppSearchTests
//
//  Created by Ahmed Mahdy on 20/09/2021.
//

import XCTest
import RxSwift
import Moya
import RxTest
@testable import FlickrAppSearch

class FlickrAppSearchTests: XCTestCase {

    var viewModel: HomeViewModel!
    var reposiotry: FlickrSearchRepository!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUp() {
        reposiotry = FlickrSearchRepository(provider: MoyaProvider<FlickrTarget>(stubClosure: MoyaProvider.immediatelyStub))
        viewModel = HomeViewModel(reposiotry)
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
    }

    override func tearDown() {
        viewModel = nil
    }

    func testPhotosSuccess() {
        let photo = scheduler.createObserver([Photo].self)
        viewModel
            .photos
            .bind(to: photo)
            .disposed(by: disposeBag)
        scheduler.start()
        viewModel.fetch()
        XCTAssertEqual(photo.events.first?.value.element?.first?.id, "51495289885")
    }

}
