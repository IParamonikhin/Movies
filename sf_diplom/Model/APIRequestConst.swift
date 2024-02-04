//
//  apiRequestModel.swift
//  sf_diplom
//
//  Created by Иван on 15.12.2023.


import Foundation

struct KinopoiskAPI {
    let kinopoiskToken = "134aebc6-5099-4a05-9579-b3f47f482aaa"
    let baseUrl = "https://kinopoiskapiunofficial.tech/api"

    enum Endpoint {
        case filmList
        case filmCard(id: Int)
        case filmImages(id: Int)
        case searchByKeyword(keyword: String)

        var path: String {
            switch self {
            case .filmList:
                return "/v2.2/films/top"
            case .filmCard(let id):
                return "/v2.2/films/\(id)"
            case .filmImages(let id):
                return "/v2.2/films/\(id)/images?type=STILL"
            case .searchByKeyword(let keyword):
                return "/v2.1/films/search-by-keyword?keyword=\(keyword)&type=FILM"
            }
        }
    }

    func buildURL(for endpoint: Endpoint, page: Int? = nil) -> URL? {
        var urlString = baseUrl + endpoint.path
        if let page = page {
            urlString += "?page=\(page)"
        }
        return URL(string: urlString)
    }
}
