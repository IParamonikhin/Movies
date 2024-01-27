//
//  FilmListProtocol.swift
//  sf_diplom
//
//  Created by Иван on 21.01.2024.
//

import Foundation
import UIKit

protocol FilmListDisplaying: AnyObject {
    var collectionView: UICollectionView! { get set }
    var model: Model { get set }

    func initializeFilmList()
    func setupFilmListCollectionView()
}
