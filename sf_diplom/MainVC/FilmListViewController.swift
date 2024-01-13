//
//  ViewController.swift
//  sf_diplom
//
//  Created by Иван on 14.12.2023.


import UIKit
import SnapKit

class FilmListViewController: UIViewController {

    private var collectionView: UICollectionView!
    private var searchBar: UISearchBar!
    var filmListVCDelegate: FilmListVCDelegate?
    var filmListVCDataSource: FilmListVCDataSource?
    let model = Model()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        
        model.requestFilmList() {
            self.collectionView.reloadData()
        } failure: { error in
            print("Failed to load film list: \(error)")
        }
    }
}

private extension FilmListViewController {

    func initialize() {
        view.backgroundColor = UIColor(named: "BackgroundColor")

        filmListVCDelegate = FilmListVCDelegate(model: model, navigationController: navigationController!)
        filmListVCDataSource = FilmListVCDataSource(model: model)

        setupSearchBar()
        setupCollectionView()
    }

    func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.placeholder = "Search Films"
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.backgroundColor = UIColor(named: "ContrastBackgroundColor")
        searchBar.delegate = filmListVCDelegate
        searchBar.showsCancelButton = true
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
        }

        // Set cancel button text color to white
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.setTitleColor(.white, for: .normal)
        }
    }

    func setupCollectionView() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.minimumInteritemSpacing = 0

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }

        collectionView.register(FilmListCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .none

        collectionView.dataSource = filmListVCDataSource
        collectionView.delegate = filmListVCDelegate
    }
}

