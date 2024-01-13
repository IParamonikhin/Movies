//
//  FilmDBModel.swift
//  sf_diplom
//
//  Created by Иван on 23.12.2023.


import Foundation
import SwiftyJSON

struct Genres {
    var genre: String
    
    init(genresDictionary: JSON) {
        genre = genresDictionary["genre"].stringValue
    }
}

struct Images {
    var imageUrl: String
    var previewUrl: String
    
    init(imagesDictionary: JSON) {
        imageUrl = imagesDictionary["imageUrl"].stringValue
        previewUrl = imagesDictionary["previewUrl"].stringValue
    }
}

struct Trailers {
    var url: String
    var name: String
    var site: String
    
    init(trailersDictionary: JSON) {
        url = trailersDictionary["url"].stringValue
        name = trailersDictionary["name"].stringValue
        site = trailersDictionary["site"].stringValue
    }
}

struct Films {
    var kinopoiskId: Int
    var nameRu: String
    var ratingKinopoisk: Double
    var year: Int
    var posterUrlPreview: String
    var favorite: Bool
    
    init(filmDictionary: JSON) {
        kinopoiskId = filmDictionary["kinopoiskId"].intValue
        nameRu = filmDictionary["nameRu"].stringValue
        ratingKinopoisk = filmDictionary["ratingKinopoisk"].doubleValue
        year = filmDictionary["year"].intValue
        posterUrlPreview = filmDictionary["posterUrlPreview"].stringValue
        favorite = false
    }
}

struct FilmCardModel {
    var kinopoiskId: Int
    var nameRu: String
    var nameOriginal: String
    var posterUrl: String
    var coverUrl: String
    var ratingKinopoisk: Double
    var year: Int
    var filmLength: Int
    var description: String
    var shortDescription: String
    var genres: [Genres]
    var images: [Images]
    var trailers: [Trailers]
    
    init(filmCadrDictionary: JSON, imagesDictionary: JSON, trailersDictionary: JSON) {
        kinopoiskId = filmCadrDictionary["kinopoiskId"].intValue
        nameRu = filmCadrDictionary["nameRu"].stringValue
        nameOriginal = filmCadrDictionary["nameOriginal"].stringValue
        posterUrl = filmCadrDictionary["posterUrl"].stringValue
        coverUrl = filmCadrDictionary["coverUrl"].stringValue
        ratingKinopoisk = filmCadrDictionary["ratingKinopoisk"].doubleValue
        year = filmCadrDictionary["year"].intValue
        filmLength = filmCadrDictionary["filmLength"].intValue
        description = filmCadrDictionary["description"].stringValue
        shortDescription = filmCadrDictionary["shortDescription"].stringValue
        genres = filmCadrDictionary["genres"].arrayValue.map { Genres(genresDictionary: $0) }
        images = imagesDictionary["items"].arrayValue.map { Images(imagesDictionary: $0) }
        trailers = trailersDictionary["items"].arrayValue.map { Trailers(trailersDictionary: $0) }
    }
}
