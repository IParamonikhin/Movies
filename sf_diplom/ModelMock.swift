//
//  ModelMock.swift
//  sf_diplom
//
//  Created by Иван on 05.03.2024.
//

import Foundation
import RealmSwift

class MockModel: Model {
    
    var getFilmFromRealmByIdCalled = false
    var updateRealmCalled = false
    var getFilmCardFromRealmByIdCalled = false
    var searchFilmsCalled = false
    
    override func getFilmFromRealmById(id: Int) -> FilmObject? {
        getFilmFromRealmByIdCalled = true
        return nil // You can return a dummy FilmObject if needed
    }
    
    override func updateRealm(with film: FilmObject) {
        updateRealmCalled = true
    }
    
    override func getFilmCardFromRealmById(id: Int, success: @escaping (FilmCardObject) -> Void, failure: @escaping (Error) -> Void) {
        getFilmCardFromRealmByIdCalled = true
        // Here you can either call the success or failure closure based on your test requirements
    }
    
    override func searchFilms(keyword: String, success: @escaping ([FilmObject]) -> Void, failure: @escaping (Error) -> Void) {
        searchFilmsCalled = true
        // Here you can either call the success or failure closure based on your test requirements
    }
}
