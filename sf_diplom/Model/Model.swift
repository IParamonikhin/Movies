//
//  Model.swift
//  sf_diplom
//
//  Created by Иван on 15.12.2023.
//

import Foundation
import Alamofire

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
    var filmList = FilmListLoadingStatistic()
    let api = KinopoiskAPI()
    
    var films: [Films] = []
    
    func request(){
        let headers = [
            "x-api-key": api.kinopoiskToken,
                "Content-Type": "application/json"
            ]
        AF.request(URL(string: (api.baseUrl + api.filmListUrl))!, headers: HTTPHeaders(headers)).responseJSON { response in
            print(response)
        }
    }
    
    func filmCellData(_ num: Int)-> FilmCellData{
        var data = FilmCellData()
        
        let film = self.films[num]
        data.imgUrl = URL(string: film.posterUrlPreview!)
        data.name = film.nameRu!
        data.rate = String(film.ratingKinopoisk!)
        data.year = String(film.year!)
        
        return data
    }
}
