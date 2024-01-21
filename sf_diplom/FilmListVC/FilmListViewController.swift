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

//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        initializeFilmList()
//
//        model.requestFilmList {
//            self.collectionView.reloadData()
//        } failure: { error in
//            print("Failed to load film list: \(error)")
//        }
//    }
  
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeFilmList()

        model.requestAllPagesAndUpdateRealm {
            // Reload collection view with data from Realm
            self.collectionView.reloadData()
        } failure: { error in
            print("Failed to load film list and update Realm: \(error)")
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}
