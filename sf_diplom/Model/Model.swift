//
//  Model.swift
//  sf_diplom
//
//  Created by Иван on 15.12.2023.


import Foundation
import Alamofire
import SwiftyJSON

// Custom errors
enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
}

struct FilmListLoadingStatistic {
    var currentPage = 0
    var pages = 0
    var loadedPage = 0
    var totalCount = 0
    var loadedCount = 0
}

struct FilmCellData {
    var imgUrl: URL?
    var name = ""
    var rate = ""
    var year = ""
}

class Model {

    var filmListStat = FilmListLoadingStatistic()

    // Define api as a lazy property
    lazy var api: KinopoiskAPI = {
        return KinopoiskAPI()
    }()

    var filmCard: FilmCardModel?
    var films: [Films] = []
    var json: JSON = JSON()

    func requestFilmList(success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        guard let url = api.buildURL(for: .filmList) else {
            failure(APIError.invalidURL)
            return
        }

        requestJSON(url: url, success: { [weak self] json in
            self?.updateFilmListStat(json)
            success()
        }, failure: { error in
            failure(error)
        })
    }

    func requestFilmCard(id: Int, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        let group = DispatchGroup()

        var filmCardJSON: JSON?
        var imagesJSON: JSON?
        var trailersJSON: JSON?

        func handleJSONResponse(url: URL, completion: @escaping (JSON) -> Void) {
            group.enter()
            requestJSON(url: url, success: { json in
                completion(json)
                group.leave()
            }, failure: { error in
                failure(error)
                group.leave()
            })
        }

        handleJSONResponse(url: api.buildURL(for: .filmCard(id: id))!) { json in
            filmCardJSON = json
        }

        handleJSONResponse(url: api.buildURL(for: .filmImages(id: id))!) { json in
            imagesJSON = json
        }

        handleJSONResponse(url: api.buildURL(for: .filmTrailers(id: id))!) { json in
            trailersJSON = json
        }

        group.notify(queue: .main) {
            if let filmCardJSON = filmCardJSON,
               let imagesJSON = imagesJSON,
               let trailersJSON = trailersJSON {
                self.filmCard = FilmCardModel(filmCadrDictionary: filmCardJSON, imagesDictionary: imagesJSON, trailersDictionary: trailersJSON)
                success()
            }
        }
    }

    func filmCellData(at index: Int) -> FilmCellData {
        let film = self.films[index]
        return FilmCellData(
            imgUrl: URL(string: film.posterUrlPreview),
            name: film.nameRu,
            rate: String(film.ratingKinopoisk),
            year: String(film.year)
        )
    }

    private func requestJSON(url: URL, success: @escaping (JSON) -> Void, failure: @escaping (Error) -> Void) {
        let headers = ["x-api-key": api.kinopoiskToken, "Content-Type": "application/json"]

        AF.request(url, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.json = json
                    success(json)

                case .failure(let error):
                    failure(APIError.networkError(error))
                }
            }
    }

    private func updateFilmListStat(_ json: JSON) {
        filmListStat.pages = json["totalPages"].intValue
        filmListStat.totalCount = json["total"].intValue

        if let mapperFilms = json["items"].array {
            filmListStat.loadedCount += mapperFilms.count
            self.films = mapperFilms.map { Films(filmDictionary: $0) }
        }
    }
}
