//
//  SearchListVCDelegate.swift
//  sf_diplom
//
//  Created by Иван on 04.02.2024.
//

import Foundation

import UIKit

class SearchListVCDelegate: NSObject, UINavigationControllerDelegate {
    
    private let borderOffset: CGFloat = 8
    
    private var navigationController: UINavigationController?
    private var model: Model!
    private var collectionView: UICollectionView?
    private var searchBar: UISearchBar?
    private var tapGestureRecognizer: UITapGestureRecognizer?
    
    init(model: Model, navigationController: UINavigationController) {
        self.model = model
        self.navigationController = navigationController
    }

    func setCollectionView(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    func setSearchBar(_ searchBar: UISearchBar) {
        self.searchBar = searchBar
        setupTapGestureRecognizer()
    }
    
    private func setupTapGestureRecognizer() {
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGestureRecognizer?.cancelsTouchesInView = false
        navigationController?.view.addGestureRecognizer(tapGestureRecognizer!)
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        searchBar?.resignFirstResponder()
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchListVCDelegate: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2
        let height = width * 1.5
        return CGSize(width: width, height: height)
    }
}


    // MARK: - UICollectionViewDelegate
    
extension SearchListVCDelegate: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           let filmObject = model.searchedFilms[indexPath.row]
           model.updateRealm(with: filmObject)
           
           let kinopoiskId = filmObject.kinopoiskId
           let isFavorite = filmObject.isFavorite
           
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
    
extension SearchListVCDelegate: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search text changed: \(searchText)")
        guard !searchText.isEmpty else {
            model.searchedFilms.removeAll()
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
            return
        }
        
        model.searchFilms(keyword: searchText, success: { [weak self] films in
            print("Search completed. Found \(films.count) films.")
            DispatchQueue.main.async {
                self?.collectionView?.reloadData()
            }
        }, failure: { error in
            print("Failed to search films: \(error)")
        })
    }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            print("Search canceled")
            searchBar.text = ""
            searchBar.resignFirstResponder()
        }
}

