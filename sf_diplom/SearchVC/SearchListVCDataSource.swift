//
//  SearchListVCDataSource.swift
//  sf_diplom
//
//  Created by Иван on 04.02.2024.
//


import Foundation
import UIKit
import RealmSwift

class SearchListVCDataSource: NSObject, UICollectionViewDataSource {
    
    private var model: Model
    
    init(model: Model) {
        self.model = model
        super.init()
    }
    
    func updateModel(_ model: Model) {
        self.model = model
    }

    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.searchedFilms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FilmListCollectionViewCell

        let filmObject = model.searchedFilms[indexPath.row]
        cell.configure(film: filmObject, model: model)

        return cell
    }
}

