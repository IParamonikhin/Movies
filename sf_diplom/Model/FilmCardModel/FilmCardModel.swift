/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct Json4Swift_Base : Mappable {
	var kinopoiskId : Int?
	var kinopoiskHDId : String?
	var imdbId : String?
	var nameRu : String?
	var nameEn : String?
	var nameOriginal : String?
	var posterUrl : String?
	var posterUrlPreview : String?
	var coverUrl : String?
	var logoUrl : String?
	var reviewsCount : Int?
	var ratingGoodReview : Double?
	var ratingGoodReviewVoteCount : Int?
	var ratingKinopoisk : Double?
	var ratingKinopoiskVoteCount : Int?
	var ratingImdb : Double?
	var ratingImdbVoteCount : Int?
	var ratingFilmCritics : Double?
	var ratingFilmCriticsVoteCount : Int?
	var ratingAwait : Double?
	var ratingAwaitCount : Int?
	var ratingRfCritics : Double?
	var ratingRfCriticsVoteCount : Int?
	var webUrl : String?
	var year : Int?
	var filmLength : Int?
	var slogan : String?
	var description : String?
	var shortDescription : String?
	var editorAnnotation : String?
	var isTicketsAvailable : Bool?
	var productionStatus : String?
	var type : String?
	var ratingMpaa : String?
	var ratingAgeLimits : String?
	var countries : [Countries]?
	var genres : [Genres]?
	var startYear : String?
	var endYear : String?
	var serial : Bool?
	var shortFilm : Bool?
	var completed : Bool?
	var hasImax : Bool?
	var has3D : Bool?
	var lastSync : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		kinopoiskId <- map["kinopoiskId"]
		kinopoiskHDId <- map["kinopoiskHDId"]
		imdbId <- map["imdbId"]
		nameRu <- map["nameRu"]
		nameEn <- map["nameEn"]
		nameOriginal <- map["nameOriginal"]
		posterUrl <- map["posterUrl"]
		posterUrlPreview <- map["posterUrlPreview"]
		coverUrl <- map["coverUrl"]
		logoUrl <- map["logoUrl"]
		reviewsCount <- map["reviewsCount"]
		ratingGoodReview <- map["ratingGoodReview"]
		ratingGoodReviewVoteCount <- map["ratingGoodReviewVoteCount"]
		ratingKinopoisk <- map["ratingKinopoisk"]
		ratingKinopoiskVoteCount <- map["ratingKinopoiskVoteCount"]
		ratingImdb <- map["ratingImdb"]
		ratingImdbVoteCount <- map["ratingImdbVoteCount"]
		ratingFilmCritics <- map["ratingFilmCritics"]
		ratingFilmCriticsVoteCount <- map["ratingFilmCriticsVoteCount"]
		ratingAwait <- map["ratingAwait"]
		ratingAwaitCount <- map["ratingAwaitCount"]
		ratingRfCritics <- map["ratingRfCritics"]
		ratingRfCriticsVoteCount <- map["ratingRfCriticsVoteCount"]
		webUrl <- map["webUrl"]
		year <- map["year"]
		filmLength <- map["filmLength"]
		slogan <- map["slogan"]
		description <- map["description"]
		shortDescription <- map["shortDescription"]
		editorAnnotation <- map["editorAnnotation"]
		isTicketsAvailable <- map["isTicketsAvailable"]
		productionStatus <- map["productionStatus"]
		type <- map["type"]
		ratingMpaa <- map["ratingMpaa"]
		ratingAgeLimits <- map["ratingAgeLimits"]
		countries <- map["countries"]
		genres <- map["genres"]
		startYear <- map["startYear"]
		endYear <- map["endYear"]
		serial <- map["serial"]
		shortFilm <- map["shortFilm"]
		completed <- map["completed"]
		hasImax <- map["hasImax"]
		has3D <- map["has3D"]
		lastSync <- map["lastSync"]
	}

}