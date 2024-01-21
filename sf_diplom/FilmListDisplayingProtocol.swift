//
//  FilmListProtocol.swift
//  sf_diplom
//
//  Created by Иван on 21.01.2024.
//

import Foundation
import UIKit

protocol FilmListDisplaying: AnyObject {
    var collectionView: UICollectionView! { get set }
    var filmListDelegate: FilmListVCDelegate? { get set }
    var filmListDataSource: FilmListVCDataSource? { get set }
    var model: Model { get set }

    func initializeFilmList()
    func setupFilmListCollectionView()
}

extension FilmListDisplaying where Self: UIViewController {
    func initializeFilmList() {
        view.backgroundColor = UIColor(named: "BackgroundColor")

        filmListDataSource = FilmListVCDataSource(model: model)

        filmListDelegate = FilmListVCDelegate(model: model, navigationController: navigationController!)
        setupFilmListCollectionView()
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

        collectionView.dataSource = filmListDataSource
        collectionView.delegate = filmListDelegate
    }
}
