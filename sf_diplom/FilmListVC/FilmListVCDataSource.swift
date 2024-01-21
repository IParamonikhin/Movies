//
//  FilmListVCDataSource.swift
//  sf_diplom
//
//  Created by Иван on 15.12.2023.
//

import Foundation
import UIKit

import Foundation
import UIKit

class FilmListVCDataSource: NSObject, UICollectionViewDataSource {
    
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
        return model.films.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FilmListCollectionViewCell
        cell.configure(film: model.filmCellData(at: indexPath.row))
        return cell
    }
}
