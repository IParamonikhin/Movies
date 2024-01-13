//
//  FilmCardVCDataSource.swift
//  sf_diplom
//
//  Created by Иван on 04.01.2024.
//

import Foundation
import UIKit

class FilmCardVCDataSource: NSObject, UICollectionViewDataSource{
    
    var images: [Images]
    
    init(images: [Images]) {
        self.images = images
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FilmCardCollectionViewCell
        cell.configure(url: URL(string: self.images[indexPath.row].previewUrl)!)
    
        return cell
    }
    
    
}