//
//  apiRequestModel.swift
//  sf_diplom
//
//  Created by Иван on 15.12.2023.
//

import Foundation

struct KinopoiskAPI {
    let kinopoiskToken = "134aebc6-5099-4a05-9579-b3f47f482aaa"
    
    let baseUrl = "https://kinopoiskapiunofficial.tech/api/v2.2"
    
    let filmListUrl = "/films?order=NUM_VOTE&type=FILM"
    let filmCardUrl = "/films"
    let filmImgUrl = "/images?type=STILL"
    let filmTrailerUrl = "/videos"
    let pageUrl = "&page="
}
