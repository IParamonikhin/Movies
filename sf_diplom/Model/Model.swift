//
//  Model.swift
//  sf_diplom
//
//  Created by Иван on 15.12.2023.
//

import Foundation
import Alamofire
import SwiftyJSON

struct FilmListLoadingStatistic{
    
    var currentPage = 0
    var pages = 0
    var loadedPage = 0
    var totalCount = 0
    var loadedCount = 0
    
    init(currentPage: Int = 0, pages: Int = 0, loadedPage: Int = 0, totalCount: Int = 0, loadedCount: Int = 0) {
        self.currentPage = currentPage
        self.pages = pages
        self.loadedPage = loadedPage
        self.totalCount = totalCount
        self.loadedCount = loadedCount
    }
}

struct FilmCellData{
    var imgUrl: URL?
    var name = ""
    var rate = ""
    var year = ""
}

enum TypeFeed: String{
    case getRecent = "NUM_VOTE"
    case favorites = "favorites"
}

class Model{
    var filmListStat = FilmListLoadingStatistic()
    let api = KinopoiskAPI()
    
    var films: [Films] = []
    
    func requestFilmList(success: @escaping() -> Void){
        let headers = [
            "x-api-key": api.kinopoiskToken,
                "Content-Type": "application/json"
            ]
        AF.request(URL(string: (api.baseUrl + api.filmListUrl))!, encoding: JSONEncoding.default, headers: HTTPHeaders(headers)).responseJSON { (apiResponse) in
            print(apiResponse)
            guard let unwrResponse = apiResponse.value else { return }
            let json = JSON(unwrResponse)
            
//            self.filmListStat.currentPage = json["page"].intValue
            self.filmListStat.pages = json["totalPages"].intValue
            self.filmListStat.totalCount = json["total"].intValue
            
            let mapper_films = JSON(rawValue: json["items"].arrayValue)
            self.filmListStat.loadedCount += mapper_films!.count
            for index in 0..<mapper_films!.count{
                self.films.append(Films(filmDictionary: JSON(rawValue: mapper_films![index])!))
            }
            success()
        }
    }
    
    func filmCellData(_ num: Int)-> FilmCellData{
        var data = FilmCellData()
        
        let film = self.films[num]
        data.imgUrl = URL(string: film.posterUrlPreview)
        data.name = film.nameRu
        data.rate = String(film.ratingKinopoisk)
        data.year = String(film.year)
        
        return data
    }
}
