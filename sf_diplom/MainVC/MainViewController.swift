//
//  ViewController.swift
//  sf_diplom
//
//  Created by Иван on 14.12.2023.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {

    private var collectionView : UICollectionView!
    var mainVCDelegate: MainVCDelegate?
    var mainVCDataSource: MainVCDataSource?
    
    let model = Model()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.request()
        initialize()
    }
    
}

private extension MainViewController{
    
    func initialize() {
        var fil = Films(map: Films)
        fil.favorite = true
        fil.kinopoiskId = 100
        fil.nameRu = "1+1"
        fil.posterUrlPreview = "https://kinopoiskapiunofficial.tech/images/posters/kp_small/535341.jpg"
        fil.ratingKinopoisk = 8.5
        fil.year = 2011
        model.films.append(fil)
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        mainVCDelegate = MainVCDelegate()
        mainVCDataSource = MainVCDataSource()
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        collectionView.register(FilmListCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .none
        collectionView.dataSource = self.mainVCDataSource
        collectionView.delegate = self.mainVCDelegate
    }
}
