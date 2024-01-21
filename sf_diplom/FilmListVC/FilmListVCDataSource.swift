//
//  FilmListVCDataSource.swift
//  sf_diplom
//
//  Created by Иван on 15.12.2023.
//

import Foundation
import UIKit
import RealmSwift

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
        do {
            let realm = try Realm()
            let filmCount = realm.objects(FilmObject.self).count
            return filmCount
        } catch {
            print("Error accessing Realm: \(error)")
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FilmListCollectionViewCell

        // Assuming you have a FilmObject class in Realm
        let filmObject = model.getFilmFromRealm(at: indexPath.row)

        // Check if the filmObject is not nil
        if let filmObject = filmObject {
            // Configure the cell using the data from Realm
            cell.configure(film: filmObject)
        } else {
            // Handle the case where data is not available
            // For example, you can set default values or display an error message
//            cell.configureDefault()
        }

        return cell
    }

}
