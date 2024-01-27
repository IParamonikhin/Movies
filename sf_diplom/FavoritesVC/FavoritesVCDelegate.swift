//
//  FavoritesVCDelegate.swift
//  sf_diplom
//
//  Created by Иван on 15.12.2023.
//

import Foundation
import UIKit

class FavoritesVCDelegate: NSObject, UINavigationControllerDelegate {
    
    private let borderOffset: CGFloat = 8
    
    private var navigationController: UINavigationController?
    private var model: Model!
    private var collectionView: UICollectionView?

    init(model: Model, navigationController: UINavigationController) {
        self.model = model
        self.navigationController = navigationController
    }

    func setCollectionView(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension FavoritesVCDelegate: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2
        let height = width * 1.5
        return CGSize(width: width, height: height)
    }
}

// MARK: - UIScrollViewDelegate

extension FavoritesVCDelegate: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height

        // Check if the user has scrolled to the bottom
        if offsetY + screenHeight >= contentHeight {
            // Load more data
//            model.loadMoreData(success: {
//                // Handle success if needed (e.g., reload collection view)
//                self.collectionView?.reloadData()
//            }, failure: { error in
//                // Handle failure if needed
//                print("Failed to load more data: \(error)")
//            })
        }
    }
}
    // MARK: - UICollectionViewDelegate
    
extension FavoritesVCDelegate: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var kinopoiskId = Int()
        var isFavorite = Bool()
        
        // Assuming you have a FilmObject class in Realm
        if let filmObject = model.getFilmFromRealm(at: indexPath.row) {
            // Film found in Realm, use its kinopoiskId
            kinopoiskId = filmObject.kinopoiskId
            isFavorite = filmObject.isFavorite
        } else {
            // Film not found in Realm, handle accordingly
            print("Film not found in Realm at index: \(indexPath.row)")
            return
        }
        
        model.getFilmCardFromRealmById(id: kinopoiskId, success: { filmCardObject in
            let vc = FilmCardViewController()
            vc.model = self.model
            vc.isFavorite = isFavorite
            vc.filmCard = filmCardObject
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.navigationBar.tintColor = .white
            self.navigationController?.pushViewController(vc, animated: true)
        }, failure: { error in
            print("Failed to load film card: \(error)")
        })
    }

}

    
    // MARK: - UISearchBarDelegate
    
extension FavoritesVCDelegate: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}

