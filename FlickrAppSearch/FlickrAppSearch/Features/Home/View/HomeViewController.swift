//
//  ViewController.swift
//  FlickrAppSearch
//
//  Created by Ahmed Mahdy on 20/09/2021.
//

import UIKit
import CoreData
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {

    @IBOutlet weak var imagesCollection: UICollectionView!
    
    private var numberOfColumns: CGFloat = 2
    private var searchBarController: UISearchController!
    private var searchTableView: UITableView!
    private var isFirstTimeActive = true

    let disposeBag = DisposeBag()
    var viewModel = HomeViewModel()
    public var photos = BehaviorRelay<[Photo]>(value: [])
    public var searchTerms = BehaviorRelay<[String]>(value: [])

    // MARK: - View's Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBindings()
        createSearchBar()
    }
    override func viewDidAppear(_ animated: Bool) {
        if isFirstTimeActive {
            searchBarController.isActive = true
            isFirstTimeActive = false
        }
    }
    // MARK: - Bindings for collectionsImages
    func setUpBindings() {
        imagesCollection.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: String(describing: ImageCollectionViewCell.self))

        // binding photos to photos
        viewModel
            .photos
            .observe(on: MainScheduler.instance)
            .bind(to: photos)
            .disposed(by: disposeBag)

        // binding loading to vc
        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .bind(to: self.rx.isAnimating)
            .disposed(by: disposeBag)
        viewModel
            .isError
            .observe(on: MainScheduler.instance)
            .bind(to: self.rx.isError)
            .disposed(by: disposeBag)

        // binding photos to umagesCollectionView
        photos.bind(to: imagesCollection.rx.items(cellIdentifier: "ImageCollectionViewCell", cellType: ImageCollectionViewCell.self)) { (row,photo,cell) in
            cell.cellPhoto = photo
            }.disposed(by: disposeBag)
        // subscribe on did select cell
        imagesCollection.rx.willDisplayCell.subscribe(onNext: {[weak self] (cell,indexPath) in
            guard let self = self else { return }
            if indexPath.row == (self.photos.value.count - 1) {
                self.viewModel.loadNextPage()
            }
        }).disposed(by: disposeBag)
        // set layout delegate for imagesCollectionView
        imagesCollection
            .rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    // MARK: - searchBar cretation
    private func createSearchBar() {
        searchBarController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchBarController
        searchBarController.delegate = self
        searchBarController.searchBar.delegate = self
        searchBarController.obscuresBackgroundDuringPresentation = false

    }
    // MARK: - LastSearchTermsTableView cretation
    private func createLastSearchTermsTableView() {
        let barHeight: CGFloat = (navigationController?.navigationBar.frame.size.height)!
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        searchTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        searchTableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: SearchTableViewCell.self))
        searchTableView.separatorColor = .clear
        self.view.addSubview(searchTableView)
        setUpTableViewBindings()
    }
    // MARK: - Bindings for LastSearchTermsTableView
    func setUpTableViewBindings() {
        viewModel
            .lastSearchTerms
            .observe(on: MainScheduler.instance)
            .bind(to: searchTerms)
            .disposed(by: disposeBag)
        searchTerms
            .bind(to: searchTableView
                .rx
                .items(cellIdentifier: String(describing: SearchTableViewCell.self),
                                               cellType: SearchTableViewCell.self))
            { (row,search,cell) in
                cell.nameLabel.text = search
            }.disposed(by: disposeBag)

        searchTableView.rx.itemSelected.subscribe(onNext: {[weak self] (indexPath) in
            guard let self = self else { return }
            let cell = self.searchTableView.cellForRow(at: indexPath) as? SearchTableViewCell
            self.searchBarController.searchBar.text = cell?.nameLabel.text
            self.searchBarSearchButtonClicked(self.searchBarController.searchBar)
        }).disposed(by: disposeBag)
    }

    func removeTableView() {
        if searchTableView != nil {
            searchTableView.removeFromSuperview()
            searchTableView = nil
        }
    }

}

// MARK: - searchBar delegates
extension HomeViewController: UISearchControllerDelegate, UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, text.count > 1 else {
            return
        }
        self.title = text
        searchBarController.isActive = false
        viewModel.saveSearchTerm(name: text)
        searchBarController.searchBar.resignFirstResponder()
        viewModel.search(with: text)
        removeTableView()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        createLastSearchTermsTableView()
        viewModel.getLastSearchTerms()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        removeTableView()
    }
}

// MARK: - collectionView layout delegates
extension HomeViewController:  UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = numberOfColumns

        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

        return CGSize(width: size, height: size)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}


