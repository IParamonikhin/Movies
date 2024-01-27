//
//  FavoritesViewController.swift
//  sf_diplom
//
//  Created by Иван on 21.01.2024.
//
import UIKit
import SnapKit

class FavoritesViewController: UIViewController, FilmListDisplaying {

    var collectionView: UICollectionView!
    var favoritesDelegate: FavoritesVCDelegate?
    var favoritesDataSource: FavoritesVCDataSource?
    var model = Model()

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeFilmList()
        setupFilmListCollectionView()

        // Load favorite films from Realm
//        if let favoriteFilms = getFavoriteFilmsFromRealm() {
//            // Populate the collection view with favorite films
//            self.favoritesDataSource?.films = favoriteFilms
            self.collectionView.reloadData()
//        } else {
//            print("Failed to load favorite films from Realm.")
//        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        // Reload collection view data every time the screen appears
        collectionView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }


    func initializeFilmList() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
        favoritesDataSource = FavoritesVCDataSource(model: model)
        favoritesDelegate = FavoritesVCDelegate(model: model, navigationController: navigationController!)
    }

    func setupFilmListCollectionView() {
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

        collectionView.dataSource = favoritesDataSource
        collectionView.delegate = favoritesDelegate
    }
}
