//
//  FilmDBModel.swift
//  sf_diplom
//
//  Created by Иван on 23.12.2023.


import Foundation
import SwiftyJSON
import RealmSwift

class GenreObject: Object {
    @objc dynamic var genre: String = ""
    
    convenience init(genresDictionary: JSON) {
        self.init()
        genre = genresDictionary["genre"].stringValue
    }
}

class ImageObject: Object {
    @objc dynamic var imageUrl: String = ""
    @objc dynamic var previewUrl: String = ""
    
    convenience init(imagesDictionary: JSON) {
        self.init()
        imageUrl = imagesDictionary["imageUrl"].stringValue
        previewUrl = imagesDictionary["previewUrl"].stringValue
    }
}

class FilmObject: Object {
    @objc dynamic var kinopoiskId: Int = 0
    @objc dynamic var nameRu: String = ""
    @objc dynamic var ratingKinopoisk: Double = 0.0
    @objc dynamic var year: Int = 0
    @objc dynamic var posterUrlPreview: String = ""
    @objc dynamic var isFavorite: Bool = false
    
    override static func primaryKey() -> String? {
          return "kinopoiskId"
      }

    convenience init(filmDictionary: JSON) {
        self.init()
        kinopoiskId = filmDictionary["kinopoiskId"].intValue
        nameRu = filmDictionary["nameRu"].stringValue
        ratingKinopoisk = filmDictionary["ratingKinopoisk"].doubleValue
        year = filmDictionary["year"].intValue
        posterUrlPreview = filmDictionary["posterUrlPreview"].stringValue
        isFavorite = false
    }
    
    func convertToFilmCellData() -> FilmCellData {
        let imgUrl = URL(string: self.posterUrlPreview)
        return FilmCellData(imgUrl: imgUrl, name: self.nameRu, rate: "\(self.ratingKinopoisk)", year: "\(self.year)")
    }
}

class FilmCardObject: Object {
    @objc dynamic var kinopoiskId: Int = 0
    @objc dynamic var nameRu: String = ""
    @objc dynamic var nameOriginal: String = ""
    @objc dynamic var posterUrl: String = ""
    @objc dynamic var coverUrl: String = ""
    @objc dynamic var ratingKinopoisk: Double = 0.0
    @objc dynamic var year: Int = 0
    @objc dynamic var filmLength: Int = 0
    @objc dynamic var filmDescription: String = ""
    @objc dynamic var shortDescription: String = ""
    var genres: List<GenreObject> = List<GenreObject>()
    var images: List<ImageObject> = List<ImageObject>()
    
    override static func primaryKey() -> String? {
          return "kinopoiskId"
      }
    
    convenience init(filmCadrDictionary: JSON, imagesDictionary: JSON) {
        self.init()
        kinopoiskId = filmCadrDictionary["kinopoiskId"].intValue
        nameRu = filmCadrDictionary["nameRu"].stringValue
        nameOriginal = filmCadrDictionary["nameOriginal"].stringValue
        posterUrl = filmCadrDictionary["posterUrl"].stringValue
        coverUrl = filmCadrDictionary["coverUrl"].stringValue
        ratingKinopoisk = filmCadrDictionary["ratingKinopoisk"].doubleValue
        year = filmCadrDictionary["year"].intValue
        filmLength = filmCadrDictionary["filmLength"].intValue
        filmDescription = filmCadrDictionary["description"].stringValue 
        shortDescription = filmCadrDictionary["shortDescription"].stringValue

        for genreJSON in filmCadrDictionary["genres"].arrayValue {
            let genreObject = GenreObject(genresDictionary: genreJSON)
            genres.append(genreObject)
        }

        for imageJSON in imagesDictionary["items"].arrayValue {
            let imageObject = ImageObject(imagesDictionary: imageJSON)
            images.append(imageObject)
        }
    }
}
