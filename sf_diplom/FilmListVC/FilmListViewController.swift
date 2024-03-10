//
//  FilmListViewController.swift
//  sf_diplom
//
//  Created by Иван on 14.12.2023.

import UIKit
import SnapKit


class FilmListViewController: UIViewController, FilmListDisplaying {

    var collectionView: UICollectionView!
    var filmListDelegate: FilmListVCDelegate?
    var filmListDataSource: FilmListVCDataSource?
    var model = Model()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "filmListViewController"
        initializeFilmList()
        setupFilmListCollectionView()

        model.requestAllPagesAndUpdateRealm {
            self.collectionView.reloadData()
        } failure: { error in
            print("Failed to load film list and update Realm: \(error)")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        collectionView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    func initializeFilmList() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
        filmListDataSource = FilmListVCDataSource(model: model)
        filmListDelegate = FilmListVCDelegate(model: model, navigationController: navigationController!)
    }

    func setupFilmListCollectionView() {
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.minimumInteritemSpacing = 0

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.addSubview(collectionView)
        collectionView.accessibilityIdentifier = "collectionView"
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.left.right.equalToSuperview()
        }

        collectionView.register(FilmListCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .none

        collectionView.dataSource = filmListDataSource
        collectionView.delegate = filmListDelegate
    }
}
