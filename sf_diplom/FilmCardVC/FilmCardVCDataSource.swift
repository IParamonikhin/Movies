//
//  FilmCardVCDataSource.swift
//  sf_diplom
//
//  Created by Иван on 04.01.2024.
//

import Foundation
import UIKit

class FilmCardVCDataSource: NSObject, UICollectionViewDataSource{
    
    var images: [ImageObject]
    var imageTappedHandler: ((URL) -> Void)?
    
    init(images: [ImageObject]) {
        self.images = images
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FilmCardCollectionViewCell
        cell.configure(url: URL(string: self.images[indexPath.row].previewUrl)!)
    
        cell.tapGestureHandler = {
                    self.imageTappedHandler?(URL(string: self.images[indexPath.row].imageUrl)!)
                }
                
        
        return cell
    }
    
    
}
