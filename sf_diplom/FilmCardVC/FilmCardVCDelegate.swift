//
//  FilmCardVCDelegate.swift
//  sf_diplom
//
//  Created by Иван on 04.01.2024.
//

import Foundation
import UIKit

class FilmCardVCDelegate: NSObject, UICollectionViewDelegateFlowLayout{
   
    var model: Model!
    
    init(model: Model) {
        self.model = model
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 10
        let height = 250
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }

}
