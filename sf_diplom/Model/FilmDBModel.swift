//
//  FilmDBModel.swift
//  sf_diplom
//
//  Created by Иван on 23.12.2023.
//

import Foundation
import ObjectMapper

struct Films : Mappable {
    var kinopoiskId : Int?
    var nameRu : String?
    var ratingKinopoisk : Double?
    var year : Int?
    var posterUrlPreview : String?
    var favorite : Bool?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        kinopoiskId <- map["kinopoiskId"]
        nameRu <- map["nameRu"]
        ratingKinopoisk <- map["ratingKinopoisk"]
        year <- map["year"]
        posterUrlPreview <- map["posterUrlPreview"]
    }

}

struct FilmCardModel : Mappable {
    var kinopoiskId : Int?
    var nameRu : String?
    var nameOriginal : String?
    var posterUrl : String?
    var posterUrlPreview : String?
    var coverUrl : String?
    var ratingKinopoisk : Double?
    var year : Int?
    var filmLength : Int?
    var description : String?
    var shortDescription : String?
    var genres : [Genres]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        kinopoiskId <- map["kinopoiskId"]
        nameRu <- map["nameRu"]
        nameOriginal <- map["nameOriginal"]
        posterUrl <- map["posterUrl"]
        coverUrl <- map["coverUrl"]
        ratingKinopoisk <- map["ratingKinopoisk"]
        year <- map["year"]
        filmLength <- map["filmLength"]
        description <- map["description"]
        shortDescription <- map["shortDescription"]
        genres <- map["genres"]
    }

}

struct Genres : Mappable {
    var genre : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        genre <- map["genre"]
    }

}
struct ImagesModel : Mappable {
    var total : Int?
    var totalPages : Int?
    var images : [Images]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        total <- map["total"]
        totalPages <- map["totalPages"]
        images <- map["items"]
    }

}
struct Images : Mappable {
    var imageUrl : String?
    var previewUrl : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        imageUrl <- map["imageUrl"]
        previewUrl <- map["previewUrl"]
    }

}
struct TrailerModel : Mappable {
    var total : Int?
    var trailers : [Trailers]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        total <- map["total"]
        trailers <- map["items"]
    }

}
struct Trailers : Mappable {
    var url : String?
    var name : String?
    var site : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        url <- map["url"]
        name <- map["name"]
        site <- map["site"]
    }

}
