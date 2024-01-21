//
//  apiRequestModel.swift
//  sf_diplom
//
//  Created by Иван on 15.12.2023.


import Foundation

struct KinopoiskAPI {
    let kinopoiskToken = "134aebc6-5099-4a05-9579-b3f47f482aaa"
    let baseUrl = "https://kinopoiskapiunofficial.tech/api/v2.2"

    enum Endpoint {
        case filmList
        case filmCard(id: Int)
        case filmImages(id: Int)
        case filmTrailers(id: Int)

        var path: String {
            switch self {
            case .filmList:
                return "/films?order=NUM_VOTE&type=FILM"
            case .filmCard(let id):
                return "/films/\(id)"
            case .filmImages(let id):
                return "/films/\(id)/images?type=STILL"
            case .filmTrailers(let id):
                return "/films/\(id)/videos"
            }
        }
    }

    func buildURL(for endpoint: Endpoint, page: Int? = nil) -> URL? {
        var urlString = baseUrl + endpoint.path
        if let page = page {
            urlString += "&page=\(page)"
        }
        return URL(string: urlString)
    }
}
