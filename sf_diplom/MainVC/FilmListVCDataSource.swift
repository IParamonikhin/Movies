//
//  MainVCDataSource.swift
//  sf_diplom
//
//  Created by Иван on 15.12.2023.
//

import Foundation
import UIKit

class MainVCDataSource: NSObject, UICollectionViewDataSource{
    
    var model: Model!
    init(model: Model) {
        self.model = model
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.films.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FilmListCollectionViewCell
        cell.configure(film: model.filmCellData(indexPath.row))
    
        
        return cell
    }
    
    
}
