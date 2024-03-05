//
//  sf_diplomTests.swift
//  sf_diplomTests
//
//  Created by Иван on 03.03.2024.
//

import XCTest

@testable import sf_diplom
import SwiftyJSON

final class sf_diplomTests: XCTestCase {

    let filmId = 123
    let filmName = "Test Film"
    let filmRating = 8.5
    let filmYear = 2022
    let filmPosterUrl = "https://example.com/poster.jpg"
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFilmObjectInitialization() {
        let filmDictionary: [String: Any] = [
            "filmId": filmId,
            "nameRu": filmName,
            "rating": filmRating,
            "year": filmYear,
            "posterUrlPreview": filmPosterUrl
        ]
        
        let filmObject = FilmObject(filmDictionary: JSON(filmDictionary))
        
        XCTAssertEqual(filmObject.kinopoiskId, filmId)
        XCTAssertEqual(filmObject.nameRu, filmName)
        XCTAssertEqual(filmObject.ratingKinopoisk, filmRating)
        XCTAssertEqual(filmObject.year, filmYear)
        XCTAssertEqual(filmObject.posterUrlPreview, filmPosterUrl)
        XCTAssertFalse(filmObject.isFavorite)
    }

    func testFilmObjectConversionToFilmCellData() {
        let filmObject = FilmObject()
        filmObject.kinopoiskId = filmId
        filmObject.nameRu = filmName
        filmObject.ratingKinopoisk = filmRating
        filmObject.year = filmYear
        filmObject.posterUrlPreview = filmPosterUrl
        
        let filmCellData = filmObject.convertToFilmCellData()
        
        XCTAssertEqual(filmCellData.id, filmId)
        XCTAssertEqual(filmCellData.name, filmName)
        XCTAssertEqual(filmCellData.rate, "\(filmRating)")
        XCTAssertEqual(filmCellData.year, "\(filmYear)")
        XCTAssertEqual(filmCellData.imgUrl?.absoluteString, filmPosterUrl)
    }

    func testFilmObjectIsFavoriteChange() {
        let mockModel = MockModel()
        let filmObject = FilmObject()
        
        XCTAssertFalse(filmObject.isFavorite)
        
        filmObject.isFavorite = true
        XCTAssertTrue(filmObject.isFavorite)
        
        filmObject.isFavorite = false
        XCTAssertFalse(filmObject.isFavorite)
    }

    func testGetFilmFromRealmById() {
        let mockModel = MockModel()
        let filmId = 123
        
        XCTAssertFalse(mockModel.getFilmFromRealmByIdCalled)
        
        _ = mockModel.getFilmFromRealmById(id: filmId)
        
        XCTAssertTrue(mockModel.getFilmFromRealmByIdCalled)
    }

    func testUpdateRealm() {
        let mockModel = MockModel()
        let newFilm = FilmObject()
        
        XCTAssertFalse(mockModel.updateRealmCalled)
        
        mockModel.updateRealm(with: newFilm)
        
        XCTAssertTrue(mockModel.updateRealmCalled)
    }

    func testGetFilmCardFromRealmById() {
        let mockModel = MockModel()
        let filmId = 123
        
        XCTAssertFalse(mockModel.getFilmCardFromRealmByIdCalled)
        
        mockModel.getFilmCardFromRealmById(id: filmId, success: { _ in }, failure: { _ in })
        
        XCTAssertTrue(mockModel.getFilmCardFromRealmByIdCalled)
    }

    func testSearchFilms() {
        let mockModel = MockModel()
        let keyword = "test"
        
        XCTAssertFalse(mockModel.searchFilmsCalled)
        
        mockModel.searchFilms(keyword: keyword, success: { _ in }, failure: { _ in })
        
        XCTAssertTrue(mockModel.searchFilmsCalled)
    }

}
