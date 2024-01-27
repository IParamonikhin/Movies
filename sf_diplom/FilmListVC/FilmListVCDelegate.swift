//
//  FilmListVCDelegate.swift
//  sf_diplom
//
//  Created by Иван on 15.12.2023.
//

import Foundation
import UIKit

class FilmListVCDelegate: NSObject, UINavigationControllerDelegate {
    
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

extension FilmListVCDelegate: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2
        let height = width * 1.5
        return CGSize(width: width, height: height)
    }
}

// MARK: - UIScrollViewDelegate

extension FilmListVCDelegate: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height

//        // Check if the user has scrolled to the bottom
//        if offsetY + screenHeight >= contentHeight {
//            // Load more data
//            model.loadMoreData(success: {
//                // Handle success if needed (e.g., reload collection view)
//                self.collectionView?.reloadData()
//            }, failure: { error in
//                // Handle failure if needed
//                print("Failed to load more data: \(error)")
//            })
//        }
    }
}
    // MARK: - UICollectionViewDelegate
    
extension FilmListVCDelegate: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        model.requestFilmCard(id: model.films[indexPath.row].kinopoiskId, success: {
            let vc = FilmCardViewController()
            vc.model = self.model
            vc.filmCard = self.model.filmCard
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.navigationBar.tintColor = .white
            self.navigationController?.pushViewController(vc, animated: true)
        }, failure: { error in
            print("Failed to load film card: \(error)")
        })
    }
}
    
    // MARK: - UISearchBarDelegate
    
extension FilmListVCDelegate: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}

