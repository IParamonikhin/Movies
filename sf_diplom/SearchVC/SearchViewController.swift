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
    var filmListDelegate: FilmListVCDelegate?
    var filmListDataSource: FilmListVCDataSource?
    var model = Model()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeFilmList()
        
        model.requestFilmList {
            self.collectionView.reloadData()
        } failure: { error in
            print("Failed to load film list: \(error)")
        }
        
        // Add a UISearchBar to the navigation bar
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Films"
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.backgroundColor = UIColor(named: "ContrastBackgroundColor")
        searchBar.delegate = filmListDelegate
        searchBar.showsCancelButton = true
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.setTitleColor(.white, for: .normal)
        }
        searchBar.backgroundColor = UIColor(named: "BackgroundColor")?.withAlphaComponent(0.5)
        
        navigationItem.titleView = searchBar
        setupNavigationBar()
    }
    
        func setupNavigationBar() {
            navigationController?.navigationItem.titleView?.backgroundColor =  UIColor(named: "BackgroundColor")?.withAlphaComponent(0.5)
            navigationController?.navigationBar.backgroundColor =  UIColor(named: "BackgroundColor")?.withAlphaComponent(0.5)
            navigationController?.navigationBar.barTintColor = UIColor(named: "BackgroundColor")?.withAlphaComponent(0.5)
        }
    
}
