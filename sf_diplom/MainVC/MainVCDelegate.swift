//
//  MainVCDelegate.swift
//  sf_diplom
//
//  Created by Иван on 15.12.2023.
//

import Foundation
import UIKit

class MainVCDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    
    private let borderOffset: CGFloat = 24
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - borderOffset) / 2
        let height = (collectionView.frame.height - borderOffset) / 2.5
        return CGSizeMake(width, height)
    }
    
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
         if scrollView.contentOffset.y + scrollView.frame.height >= scrollView.contentSize.height {
//             uploadData()
         }
    }
}
