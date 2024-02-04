//
//  SearchViewController.swift
//  sf_diplom
//
//  Created by Иван on 21.01.2024.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController, FilmListDisplaying {
    
    var collectionView: UICollectionView!
    var searchListDelegate: SearchListVCDelegate?
    var searchListDataSource: SearchListVCDataSource?
    var model = Model()
    let searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeFilmList()
        
        // Initialize searchListDelegate
        searchListDelegate = SearchListVCDelegate(model: model, navigationController: self.navigationController!)
        //           searchListDelegate?.setCollectionView(collectionView)
        
        // Initialize searchListDataSource
        searchListDataSource = SearchListVCDataSource(model: model)
        
        //           model.requestFilmList {
        //               self.collectionView.reloadData()
        //           } failure: { error in
        //               print("Failed to load film list: \(error)")
        //           }
        
//        searchBar.placeholder = "Search Films"
        if let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField {
            let placeholderText = NSAttributedString(string: "Search Films", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "BackgroundColor") ?? UIColor.gray])
            textFieldInsideSearchBar.attributedPlaceholder = placeholderText
        }
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.backgroundColor = UIColor(named: "ContrastBackgroundColor")
        searchBar.searchTextField.tintColor = UIColor(named: "BackgroundColor")
        searchBar.delegate = searchListDelegate
        searchBar.showsCancelButton = true
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.setTitleColor(.white, for: .normal)
        }
        searchBar.backgroundColor = UIColor(named: "BackgroundColor")?.withAlphaComponent(0.5)
        
        navigationItem.titleView = searchBar
        setupNavigationBar()
        
        // Now call searchFilms after initializing collectionView
        setupFilmListCollectionView()
    }
       
       // MARK: - UISearchBarDelegate
       
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }


    func setupNavigationBar() {
        navigationController?.navigationItem.titleView?.backgroundColor = UIColor(named: "BackgroundColor")?.withAlphaComponent(0.5)
        navigationController?.navigationBar.backgroundColor = UIColor(named: "BackgroundColor")?.withAlphaComponent(0.5)
        navigationController?.navigationBar.barTintColor = UIColor(named: "BackgroundColor")?.withAlphaComponent(0.5)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         // Clear the searched films when the view is about to disappear
//         model.searchedFilms.removeAll()
     }
    
    func initializeFilmList() {
        // Setup collection view and other film list components
        setupFilmListCollectionView()
    }
    
    func setupFilmListCollectionView() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.minimumInteritemSpacing = 0

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.left.right.equalToSuperview()
        }

        collectionView.register(FilmListCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .none

        collectionView.dataSource = searchListDataSource
        collectionView.delegate = searchListDelegate
        searchListDelegate?.setCollectionView(collectionView)
    }
    
}
