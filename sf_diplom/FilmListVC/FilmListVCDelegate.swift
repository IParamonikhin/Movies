//
//  MainVCDelegate.swift
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

    init(model: Model, navigationController: UINavigationController) {
        self.model = model
        self.navigationController = navigationController
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
        if scrollView.contentOffset.y + scrollView.frame.height >= scrollView.contentSize.height {
            // Load more data
            // uploadData()
        }
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
