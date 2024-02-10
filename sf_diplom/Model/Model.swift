import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
}

struct FilmListLoadingStatistic {
    var currentPage = 0
    var pages = 1
    var loadedPage = 0
    var totalCount = 0
    var loadedCount = 0
}

struct FilmCellData {
    var id = Int()
    var imgUrl: URL?
    var name = ""
    var rate = ""
    var year = ""
}

class Model {
    var filmListStat = FilmListLoadingStatistic()
    
    lazy var api: KinopoiskAPI = {
        return KinopoiskAPI()
    }()
    
    var films: [FilmObject] = []
    var searchedFilms: [FilmObject] = []
    
    // MARK: - Film Card
    
    var filmCard: FilmCardObject?
    
    // MARK: - API Requests
    
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
    
    func requestAllPagesAndUpdateRealm(success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        filmListStat = FilmListLoadingStatistic()
        let firstPageRequestGroup = DispatchGroup()
        firstPageRequestGroup.enter()
        
        guard let firstPageURL = api.buildURL(for: .filmList, page: 1) else {
            failure(APIError.invalidURL)
            return
        }
        
        requestJSON(url: firstPageURL, success: { [weak self] json in
            guard let self = self else { return }
            
            self.updateFilmListStat(json)
            
            print("Updated page count: \(self.filmListStat.pages)")
            
            firstPageRequestGroup.leave()
        }, failure: { error in
            firstPageRequestGroup.leave()
            failure(error)
        })
        
        firstPageRequestGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            
            let allPagesRequestGroup = DispatchGroup()
            
            allPagesRequestGroup.enter()
            
            for page in 1...self.filmListStat.pages {
                guard let url = self.api.buildURL(for: .filmList, page: page) else {
                    failure(APIError.invalidURL)
                    return
                }
                
                allPagesRequestGroup.enter()
                
                self.requestJSON(url: url, success: { json in
                    self.updateRealm(with: json)
                    allPagesRequestGroup.leave()
                }, failure: { error in
                    allPagesRequestGroup.leave()
                    failure(error)
                })
            }
                        allPagesRequestGroup.notify(queue: .main) {
                success()
            }
            
            allPagesRequestGroup.leave()
        }
    }

    
    // MARK: - Local Data Store
    
    private func updateRealm(with json: JSON) {
        do {
            let realm = try Realm()
            
            print(realm.configuration.fileURL!)
            
            try realm.write {
                if let mapperFilms = json["films"].array {
                    for filmJson in mapperFilms {
                        guard let kinopoiskId = filmJson["filmId"].int else {
                            continue
                        }
                        if let existingFilm = realm.object(ofType: FilmObject.self, forPrimaryKey: kinopoiskId) {
                            existingFilm.nameRu = filmJson["nameRu"].stringValue
                            existingFilm.ratingKinopoisk = filmJson["rating"].doubleValue
                            existingFilm.year = filmJson["year"].intValue
                            existingFilm.posterUrlPreview = filmJson["posterUrlPreview"].stringValue
                            
                        } else {
                            let newFilm = FilmObject(filmDictionary: filmJson)
                            realm.add(newFilm, update: .modified)
                        }
                    }
                }
            }
        } catch {
            print("Error updating Realm: \(error)")
        }
    }
    func updateRealm(with filmObject: FilmObject) {
        let realm = try! Realm()
        do {
            try realm.write {
                realm.add(filmObject, update: .modified)
            }
        } catch {
            print("Error updating Realm: \(error)")
        }
    }
    
    // MARK: - JSON Request
    
    private func requestJSON(url: URL, success: @escaping (JSON) -> Void, failure: @escaping (Error) -> Void) {
        let headers = ["x-api-key": api.kinopoiskToken, "Content-Type": "application/json"]
        
        AF.request(url, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    success(json)
                    
                case .failure(let error):
                    failure(APIError.networkError(error))
                }
            }
    }
    
    // MARK: - Statistic Update
    
    private func updateFilmListStat(_ json: JSON) {
        filmListStat.pages = json["pagesCount"].intValue
        filmListStat.totalCount = json["total"].intValue
        
        if let mapperFilms = json["films"].array {
            filmListStat.loadedCount += mapperFilms.count
        }
    }
    
    // MARK: - Film Cell Data
    
    func filmCellData(at index: Int) -> FilmCellData {
        let film = self.films[index]
        return FilmCellData(
            id: film.kinopoiskId,
            imgUrl: URL(string: film.posterUrlPreview),
            name: film.nameRu,
            rate: String(film.ratingKinopoisk),
            year: String(film.year)
        )
    }
    
    // MARK: - API Request if Film not in Realm
    
    internal func getFilmCardFromRealmById(id: Int, success: @escaping (FilmCardObject) -> Void, failure: @escaping (Error) -> Void) {
        do {
            let realm = try Realm()
            
            if let existingFilm = realm.object(ofType: FilmCardObject.self, forPrimaryKey: id) {
                success(existingFilm)
            } else {
                requestFilmById(id: id, success: {
                    if let filmCardObject = realm.object(ofType: FilmCardObject.self, forPrimaryKey: id) {
                        success(filmCardObject)
                    } else {
                        failure(APIError.invalidResponse)
                    }
                }, failure: { error in
                    failure(error)
                })
            }
        } catch {
            print("Error reading film from Realm: \(error)")
            failure(error)
        }
    }
    private func requestFilmById(id: Int, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        let group = DispatchGroup()
        
        var filmJSON: JSON?
        var imagesJSON: JSON?
        
        group.enter()
        guard let filmUrl = api.buildURL(for: .filmCard(id: id)) else {
            failure(APIError.invalidURL)
            return
        }
        requestJSON(url: filmUrl, success: { json in
            filmJSON = json
            group.leave()
        }, failure: { error in
            failure(error)
            group.leave()
        })
        
        group.enter()
        guard let imagesUrl = api.buildURL(for: .filmImages(id: id)) else {
            failure(APIError.invalidURL)
            return
        }
        requestJSON(url: imagesUrl, success: { json in
            imagesJSON = json
            group.leave()
        }, failure: { error in
            failure(error)
            group.leave()
        })
        
        group.notify(queue: .main) {
            guard let filmJSON = filmJSON, let imagesJSON = imagesJSON else {
                failure(APIError.invalidResponse)
                return
            }
            
            self.updateRealmWithFilmCard(json: filmJSON, imagesJSON: imagesJSON)
            success()
        }
    }

    private func updateRealmWithFilmCard(json: JSON, imagesJSON: JSON) {
        do {
            let realm = try Realm()
            try realm.write {
                let filmCadrDictionary = json.dictionaryValue
                
                let filmCard = FilmCardObject(filmCadrDictionary: JSON(filmCadrDictionary), imagesDictionary: imagesJSON)
                
                realm.add(filmCard, update: .modified)
            }
        } catch {
            print("Error updating Realm with film card: \(error)")
        }
    }


    // MARK: - Get Film List from Realm or API
    
    internal func getFilmListFromRealm(success: @escaping ([FilmObject]) -> Void, failure: @escaping (Error) -> Void) {
        do {
            let realm = try Realm()
            
            let filmList = realm.objects(FilmObject.self)
            if !filmList.isEmpty {
                success(Array(filmList))
            } else {
                requestFilmList(success: { [weak self] in
                    if let films = self?.getFilmsFromRealm() {
                        success(films)
                    } else {
                        failure(APIError.invalidResponse)
                    }
                }, failure: { error in
                    failure(error)
                })
            }
        } catch {
            print("Error reading film list from Realm: \(error)")
            failure(error)
        }
    }
    
    private func getFilmsFromRealm() -> [FilmObject]? {
        do {
            let realm = try Realm()
            return Array(realm.objects(FilmObject.self))
        } catch {
            // Handle Realm errors
            print("Error reading films from Realm: \(error)")
            return nil
        }
    }
    
    // MARK: - Get Film from Realm by Index
    
    func getFilmFromRealm(at index: Int) -> FilmObject? {
        do {
            let realm = try Realm()

            let films = realm.objects(FilmObject.self).sorted(byKeyPath: "ratingKinopoisk", ascending: false)

            guard index < films.count else {
                print("Index out of bounds: \(index)")
                return nil
            }

            let filmObject = films[index]
            return filmObject
        } catch {
            print("Error accessing Realm: \(error)")
            return nil
        }
    }
    
    func getFavoritesFilmFromRealm(at index: Int) -> FilmObject? {
        do {
            let realm = try Realm()

            let films = realm.objects(FilmObject.self).filter("isFavorite == true").sorted(byKeyPath: "ratingKinopoisk", ascending: false)

            guard index < films.count else {
                print("Index out of bounds: \(index)")
                return nil
            }

            let filmObject = films[index]
            return filmObject
        } catch {
            print("Error accessing Realm: \(error)")
            return nil
        }
    }
    
    func getFilmFromRealmById(id: Int) -> FilmObject? {
        do {
            let realm = try Realm()

            if let filmObject = realm.object(ofType: FilmObject.self, forPrimaryKey: id) {
                return filmObject
            } else {
                print("Film with ID \(id) not found in Realm")
                return nil
            }
        } catch {
            print("Error accessing Realm: \(error)")
            return nil
        }
    }
    
    func getFavoriteFilmFromRealm(at index: Int) -> FilmObject? {
        do {
            let realm = try Realm()

            let favoriteFilms = realm.objects(FilmObject.self).filter("isFavorite == true").sorted(byKeyPath: "ratingKinopoisk", ascending: false)

            guard index < favoriteFilms.count else {
                print("Index out of bounds: \(index)")
                return nil
            }

            let filmObject = favoriteFilms[index]
            return filmObject
        } catch {
            print("Error accessing Realm: \(error)")
            return nil
        }
    }
    
    func searchFilms(keyword: String, success: @escaping ([FilmObject]) -> Void, failure: @escaping (Error) -> Void) {
        guard let encodedKeyword = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            failure(APIError.invalidURL)
            return
        }
        
        guard let url = api.buildURL(for: .searchByKeyword(keyword: encodedKeyword)) else {
            failure(APIError.invalidURL)
            return
        }
        
        requestJSON(url: url, success: { json in
            guard let filmsJSON = json["films"].array else {
                failure(APIError.invalidResponse)
                return
            }
            
            var films: [FilmObject] = []
            
            for filmJSON in filmsJSON {
                let film = FilmObject(filmDictionary: filmJSON)
                films.append(film)
            }
            self.searchedFilms = films
            
            success(films)
        }, failure: { error in
            failure(error)
        })
    }
    

}
