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
        model.requestFilmList(){
            self.collectionView.reloadData()
        }
        model.requestFilmCard(id: 1143242){
            self.collectionView.reloadData()
        }
        initialize()
    }
    
}

private extension MainViewController{
    
    func initialize() {
        
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        mainVCDelegate = MainVCDelegate()
        mainVCDataSource = MainVCDataSource(model: model)
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview()//.offset(8)
            make.right.equalToSuperview()//.inset(8)
        }
        collectionView.register(FilmListCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .none
        collectionView.dataSource = self.mainVCDataSource
        collectionView.delegate = self.mainVCDelegate
    }
}
