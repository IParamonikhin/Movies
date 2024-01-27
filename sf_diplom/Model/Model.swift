//import Foundation
//import Alamofire
//import SwiftyJSON
//import RealmSwift
//
//enum APIError: Error {
//    case invalidURL
//    case networkError(Error)
//    case invalidResponse
//}
//
//struct FilmListLoadingStatistic {
//    var currentPage = 0
//    var pages = 1
//    var loadedPage = 0
//    var totalCount = 0
//    var loadedCount = 0
//}
//
//struct FilmCellData {
//    var id = Int()
//    var imgUrl: URL?
//    var name = ""
//    var rate = ""
//    var year = ""
//}
//
//class Model {
//    var filmListStat = FilmListLoadingStatistic()
//    
//    lazy var api: KinopoiskAPI = {
//        return KinopoiskAPI()
//    }()
//    
//    var films: [FilmObject] = []
//    
//    // MARK: - Film Card
//    
//    var filmCard: FilmCardObject?
//    // MARK: - API Requests
//    
//    func requestFilmList(success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
//        guard let url = api.buildURL(for: .filmList) else {
//            failure(APIError.invalidURL)
//            return
//        }
//        
//        requestJSON(url: url, success: { [weak self] json in
//            self?.updateFilmListStat(json)
//            success()
//        }, failure: { error in
//            failure(error)
//        })
//    }
//    func requestAllPagesAndUpdateRealm(success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
//        // Reset filmListStat for a fresh start
//        filmListStat = FilmListLoadingStatistic()
//        
//        // Check if there are pages to request
//        guard filmListStat.pages > 0 else {
//            // No pages to request, handle accordingly
//            failure(APIError.invalidURL)
//            return
//        }
//        
//        // Create a dispatch group to synchronize completion of the first request
//        let firstRequestGroup = DispatchGroup()
//        
//        // Enter the dispatch group before the first request
//        firstRequestGroup.enter()
//        
//        // Request the first page to update filmListStat
//        guard let firstPageURL = api.buildURL(for: .filmList, page: 1) else {
//            failure(APIError.invalidURL)
//            return
//        }
//        
//        requestJSON(url: firstPageURL, success: { [weak self] json in
//            self?.updateFilmListStat(json)
//            firstRequestGroup.leave() // Leave the dispatch group after the first request is complete
//        }, failure: { error in
//            firstRequestGroup.leave() // Leave the dispatch group even if there's a failure
//            failure(error)
//        })
//        
//        // Notify after the first request to update filmListStat completes
//        firstRequestGroup.notify(queue: .main) { [weak self] in
//            guard let self = self else { return }
//            
//            // Iterate over all pages and request data for each
//            for page in 1...self.filmListStat.pages {
//                guard let url = self.api.buildURL(for: .filmList, page: page) else {
//                    failure(APIError.invalidURL)
//                    return
//                }
//                
//                // Create a dispatch group for each page request
//                let pageRequestGroup = DispatchGroup()
//                pageRequestGroup.enter() // Enter the dispatch group before each page request
//                
//                self.requestJSON(url: url, success: { json in
//                    self.updateRealm(with: json)
//                    pageRequestGroup.leave() // Leave the dispatch group after each page request is complete
//                }, failure: { error in
//                    pageRequestGroup.leave() // Leave the dispatch group even if there's a failure
//                    failure(error)
//                })
//            }
//            
//            // Notify success after all pages are loaded and Realm is updated
//            success()
//        }
//    }
//    
//    // MARK: - Local Data Store
//    
//    private func updateRealm(with json: JSON) {
//        do {
//            // Create Realm instance
//            let realm = try Realm()
//            
//            // Print the file URL of the Realm database
//            print(realm.configuration.fileURL)
//            
//            // Update Realm here with the json data
//            try realm.write {
//                if let mapperFilms = json["items"].array {
//                    let films = mapperFilms.map { FilmObject(filmDictionary: $0) }
//                    
//                    // Assuming FilmObject is a Realm Object, add them to the Realm
//                    realm.add(films, update: .modified)
//                }
//            }
//        } catch {
//            // Handle Realm errors
//            print("Error updating Realm: \(error)")
//        }
//    }
//    // MARK: - JSON Request
//    
//    private func requestJSON(url: URL, success: @escaping (JSON) -> Void, failure: @escaping (Error) -> Void) {
//        let headers = ["x-api-key": api.kinopoiskToken, "Content-Type": "application/json"]
//        
//        AF.request(url, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
//            .validate()
//            .responseJSON { response in
//                switch response.result {
//                case .success(let value):
//                    let json = JSON(value)
//                    success(json)
//                    
//                case .failure(let error):
//                    failure(APIError.networkError(error))
//                }
//            }
//    }
//    
//    // MARK: - Statistic Update
//    
//    private func updateFilmListStat(_ json: JSON) {
//        filmListStat.pages = json["totalPages"].intValue
//        filmListStat.totalCount = json["total"].intValue
//        
//        if let mapperFilms = json["items"].array {
//            filmListStat.loadedCount += mapperFilms.count
//        }
//    }
//    
//    // MARK: - Film Cell Data
//    
//    func filmCellData(at index: Int) -> FilmCellData {
//        let film = self.films[index]
//        return FilmCellData(
//            id: film.kinopoiskId,
//            imgUrl: URL(string: film.posterUrlPreview),
//            name: film.nameRu,
//            rate: String(film.ratingKinopoisk),
//            year: String(film.year)
//        )
//    }
//    
//    // MARK: - API Request if Film not in Realm
//    
////    func getFilmByIdFromRealmOrAPI(id: Int, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
////        // Check if the film with the given ID exists in Realm
////        if let existingFilm = getFilmCardFromRealmById(id: id) {
////            // Film found in Realm, no need to make an API request
////            self.filmCard = existingFilm
////            success()
////        } else {
////            // Film not found in Realm, make an API request
////            requestFilmById(id: id, success: {
////                success()
////            }, failure: { error in
////                failure(error)
////            })
////        }
////    }
//    internal func getFilmCardFromRealmById(id: Int, success: @escaping (FilmCardObject) -> Void, failure: @escaping (Error) -> Void) {
//        do {
//            let realm = try Realm()
//            
//            // Check if the film with the given ID exists in Realm
//            if let existingFilm = realm.object(ofType: FilmCardObject.self, forPrimaryKey: id) {
//                // Film found in Realm, return it
//                success(existingFilm)
//            } else {
//                // Film not found in Realm, make an API request
//                requestFilmById(id: id, success: {
//                    // Since the success closure in requestFilmById doesn't provide the fetched FilmCardObject directly,
//                    // you need to handle it here, for example by fetching the film again from Realm after the API request
//                    if let filmCardObject = realm.object(ofType: FilmCardObject.self, forPrimaryKey: id) {
//                        success(filmCardObject)
//                    } else {
//                        // If the film still couldn't be found in Realm after the API request, handle it accordingly
//                        failure(APIError.invalidResponse)
//                    }
//                }, failure: { error in
//                    // Handle API request failure
//                    failure(error)
//                })
//            }
//        } catch {
//            // Handle Realm errors
//            print("Error reading film from Realm: \(error)")
//            failure(error)
//        }
//    }
//    
//    private func requestFilmById(id: Int, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
//        guard let url = api.buildURL(for: .filmCard(id: id)) else {
//            failure(APIError.invalidURL)
//            return
//        }
//        
//        requestJSON(url: url, success: { [weak self] json in
//            // Update Realm with the fetched film data
//            self?.updateRealmWithFilm(json: json)
//            success()
//        }, failure: { error in
//            failure(error)
//        })
//    }
//    
//    private func updateRealmWithFilm(json: JSON) {
//        do {
//            let realm = try Realm()
//            
//            try realm.write {
//                if let filmCadrDictionary = json["film"].dictionary,
//                   let imagesDictionary = json["images"].dictionary {
//                    
//                    // Create a FilmCardObject using the fetched data
//                    let filmObject = FilmCardObject(filmCadrDictionary: JSON(filmCadrDictionary),
//                                                    imagesDictionary: JSON(imagesDictionary))
//                    
//                    // Add or update the film in Realm
//                    realm.add(filmObject, update: .modified)
//                }
//            }
//        } catch {
//            // Handle Realm errors
//            print("Error updating Realm with film: \(error)")
//        }
//    }
//    
////    func getFilmFromRealm(at index: Int) -> FilmObject? {
////        do {
////            let realm = try Realm()
////            
////            // Assuming you have a primary key for FilmObject and the primary key is an integer
////            if let filmObject = realm.object(ofType: FilmObject.self, forPrimaryKey: index) {
////                return filmObject
////            } else {
////                // Handle the case where the filmObject is not found
////                print("FilmObject not found in Realm at index: \(index)")
////                return nil
////            }
////        } catch {
////            // Handle Realm errors
////            print("Error accessing Realm: \(error)")
////            return nil
////        }
////    }
//    
//    func getFilmFromRealm(at index: Int) -> FilmObject? {
//        do {
//            let realm = try Realm()
//
//            // Assuming you have a primary key for FilmObject and the primary key is an integer
//            let films = realm.objects(FilmObject.self).sorted(byKeyPath: "ratingKinopoisk", ascending: false)
//
//
//            guard index < films.count else {
//                // Handle the case where the index is out of bounds
//                print("Index out of bounds: \(index)")
//                return nil
//            }
//
//            let filmObject = films[index]
//            return filmObject
//        } catch {
//            // Handle Realm errors
//            print("Error accessing Realm: \(error)")
//            return nil
//        }
//    }
//    
//}
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
        // Reset filmListStat for a fresh start
        filmListStat = FilmListLoadingStatistic()
        
        // Log initial page count
        print("Initial page count: \(filmListStat.pages)")
        
        // Create a dispatch group to synchronize completion of the first request
        let firstPageRequestGroup = DispatchGroup()
        
        // Enter the dispatch group before the first request
        firstPageRequestGroup.enter()
        
        // Request the first page to update filmListStat
        guard let firstPageURL = api.buildURL(for: .filmList, page: 1) else {
            failure(APIError.invalidURL)
            return
        }
        
        requestJSON(url: firstPageURL, success: { [weak self] json in
            guard let self = self else { return }
            
            // Update filmListStat with data from the first page
            self.updateFilmListStat(json)
            
            // Log updated page count
            print("Updated page count: \(self.filmListStat.pages)")
            
            // Leave the dispatch group after the first request is complete
            firstPageRequestGroup.leave()
        }, failure: { error in
            // Leave the dispatch group even if there's a failure
            firstPageRequestGroup.leave()
            failure(error)
        })
        
        // Notify after the first request to update filmListStat completes
        firstPageRequestGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            
            // Create a dispatch group to synchronize completion of all page requests
            let allPagesRequestGroup = DispatchGroup()
            
            // Enter the dispatch group before iterating over each page
            allPagesRequestGroup.enter()
            
            // Iterate over all pages and request data for each
            for page in 1...self.filmListStat.pages {
                guard let url = self.api.buildURL(for: .filmList, page: page) else {
                    failure(APIError.invalidURL)
                    return
                }
                
                // Enter the dispatch group before each page request
                allPagesRequestGroup.enter()
                
                self.requestJSON(url: url, success: { json in
                    // Log page number and response data
                    print("Page \(page) loaded")
                    
                    // Update Realm with data from the current page
                    self.updateRealm(with: json)
                    
                    // Leave the dispatch group after each page request is complete
                    allPagesRequestGroup.leave()
                }, failure: { error in
                    // Leave the dispatch group even if there's a failure
                    allPagesRequestGroup.leave()
                    failure(error)
                })
            }
            
            // Notify success after all pages are loaded and Realm is updated
            allPagesRequestGroup.notify(queue: .main) {
                success()
            }
            
            // Leave the dispatch group after iterating over all pages
            allPagesRequestGroup.leave()
        }
    }

    
    // MARK: - Local Data Store
    
    private func updateRealm(with json: JSON) {
        do {
            // Create Realm instance
            let realm = try Realm()
            
            // Print the file URL of the Realm database
            print(realm.configuration.fileURL)
            
            // Update Realm here with the json data
            try realm.write {
                if let mapperFilms = json["items"].array {
                    for filmJson in mapperFilms {
                        guard let kinopoiskId = filmJson["kinopoiskId"].int else {
                            continue
                        }
                        
                        // Fetch existing FilmObject from Realm
                        if let existingFilm = realm.object(ofType: FilmObject.self, forPrimaryKey: kinopoiskId) {
                            // Update properties except isFavorite
                            existingFilm.nameRu = filmJson["nameRu"].stringValue
                            existingFilm.ratingKinopoisk = filmJson["ratingKinopoisk"].doubleValue
                            existingFilm.year = filmJson["year"].intValue
                            existingFilm.posterUrlPreview = filmJson["posterUrlPreview"].stringValue
                            
                            // Other properties update...
                        } else {
                            // Create new FilmObject if not exists
                            let newFilm = FilmObject(filmDictionary: filmJson)
                            realm.add(newFilm, update: .modified)
                        }
                    }
                }
            }
        } catch {
            // Handle Realm errors
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
        filmListStat.pages = json["totalPages"].intValue
        filmListStat.totalCount = json["total"].intValue
        
        if let mapperFilms = json["items"].array {
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
            
            // Check if the film with the given ID exists in Realm
            if let existingFilm = realm.object(ofType: FilmCardObject.self, forPrimaryKey: id) {
                // Film found in Realm, return it
                success(existingFilm)
            } else {
                // Film not found in Realm, make an API request
                requestFilmById(id: id, success: {
                    // Since the success closure in requestFilmById doesn't provide the fetched FilmCardObject directly,
                    // you need to handle it here, for example by fetching the film again from Realm after the API request
                    if let filmCardObject = realm.object(ofType: FilmCardObject.self, forPrimaryKey: id) {
                        success(filmCardObject)
                    } else {
                        // If the film still couldn't be found in Realm after the API request, handle it accordingly
                        failure(APIError.invalidResponse)
                    }
                }, failure: { error in
                    // Handle API request failure
                    failure(error)
                })
            }
        } catch {
            // Handle Realm errors
            print("Error reading film from Realm: \(error)")
            failure(error)
        }
    }
    private func requestFilmById(id: Int, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        // Dispatch group to synchronize the completion of multiple requests
        let group = DispatchGroup()
        
        var filmJSON: JSON?
        var imagesJSON: JSON?
        
        // Request film card data
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
        
        // Request images data
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
        
        // Notify when both requests are complete
        group.notify(queue: .main) {
            guard let filmJSON = filmJSON, let imagesJSON = imagesJSON else {
                failure(APIError.invalidResponse)
                return
            }
            
            // Update Realm with the fetched film data and images
            self.updateRealmWithFilmCard(json: filmJSON, imagesJSON: imagesJSON)
            success()
        }
    }

    private func updateRealmWithFilmCard(json: JSON, imagesJSON: JSON) {
        do {
            let realm = try Realm()
            try realm.write {
                // Parse the film card data
                let filmCadrDictionary = json.dictionaryValue // Assuming the film card data is directly in the JSON response
                
                // Create a FilmCardObject using the film card data
                let filmCard = FilmCardObject(filmCadrDictionary: JSON(filmCadrDictionary), imagesDictionary: imagesJSON)
                
                // Add or update the film card in Realm
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
            
            // Check if film list exists in Realm
            let filmList = realm.objects(FilmObject.self)
            if !filmList.isEmpty {
                // Film list found in Realm, return it
                success(Array(filmList))
            } else {
                // Film list not found in Realm, make an API request
                requestFilmList(success: { [weak self] in
                    // After successful API request, attempt to fetch the film list from Realm again
                    if let films = self?.getFilmsFromRealm() {
                        success(films)
                    } else {
                        // If the film list still couldn't be found in Realm after the API request, handle it accordingly
                        failure(APIError.invalidResponse)
                    }
                }, failure: { error in
                    // Handle API request failure
                    failure(error)
                })
            }
        } catch {
            // Handle Realm errors
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

            // Assuming you have a primary key for FilmObject and the primary key is an integer
            let films = realm.objects(FilmObject.self).sorted(byKeyPath: "ratingKinopoisk", ascending: false)

            guard index < films.count else {
                // Handle the case where the index is out of bounds
                print("Index out of bounds: \(index)")
                return nil
            }

            let filmObject = films[index]
            return filmObject
        } catch {
            // Handle Realm errors
            print("Error accessing Realm: \(error)")
            return nil
        }
    }
    
    func getFilmFromRealmById(id: Int) -> FilmObject? {
        do {
            let realm = try Realm()

            // Retrieve the film with the given ID from Realm
            if let filmObject = realm.object(ofType: FilmObject.self, forPrimaryKey: id) {
                return filmObject
            } else {
                // Handle the case where the film with the given ID is not found
                print("Film with ID \(id) not found in Realm")
                return nil
            }
        } catch {
            // Handle Realm errors
            print("Error accessing Realm: \(error)")
            return nil
        }
    }
    func getFavoriteFilmFromRealm(at index: Int) -> FilmObject? {
        do {
            let realm = try Realm()

            // Fetch films where isFavorite is true, sorted by ratingKinopoisk
            let favoriteFilms = realm.objects(FilmObject.self).filter("isFavorite == true").sorted(byKeyPath: "ratingKinopoisk", ascending: false)

            guard index < favoriteFilms.count else {
                // Handle the case where the index is out of bounds
                print("Index out of bounds: \(index)")
                return nil
            }

            let filmObject = favoriteFilms[index]
            return filmObject
        } catch {
            // Handle Realm errors
            print("Error accessing Realm: \(error)")
            return nil
        }
    }
//    func getFavoriteFilmsFromRealm() -> [FilmObject]? {
//        do {
//            let realm = try Realm()
//            // Filter films where isFavorite is true
//            let favoriteFilms = realm.objects(FilmObject.self).filter("favorite == true")
//            return Array(favoriteFilms)
//        } catch {
//            // Handle Realm errors
//            print("Error reading favorite films from Realm: \(error)")
//            return nil
//        }
//    }

}
