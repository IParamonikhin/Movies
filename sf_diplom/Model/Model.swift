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
        
        // Check if there are pages to request
        guard filmListStat.pages > 0 else {
            // No pages to request, handle accordingly
            failure(APIError.invalidURL)
            return
        }
        
        // Iterate over all pages and request data for each
        for page in 1...filmListStat.pages {
            guard let url = api.buildURL(for: .filmList, page: page) else {
                failure(APIError.invalidURL)
                return
            }
            
            requestJSON(url: url, success: { [weak self] json in
                self?.updateFilmListStat(json)
                self?.updateRealm(with: json)
                // Notify success after all pages are loaded and Realm is updated
                success()
            }, failure: { error in
                // Handle failure for a specific page
                failure(error)
            })
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
                    let films = mapperFilms.map { FilmObject(filmDictionary: $0) }
                    
                    // Assuming FilmObject is a Realm Object, add them to the Realm
                    realm.add(films, update: .modified)
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
    
    func getFilmByIdFromRealmOrAPI(id: Int, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        // Check if the film with the given ID exists in Realm
        if let existingFilm = getFilmFromRealmById(id: id) {
            // Film found in Realm, no need to make an API request
            self.filmCard = existingFilm
            success()
        } else {
            // Film not found in Realm, make an API request
            requestFilmById(id: id, success: {
                success()
            }, failure: { error in
                failure(error)
            })
        }
    }
    
    internal func getFilmFromRealmById(id: Int) -> FilmCardObject? {
        do {
            let realm = try Realm()
            return realm.object(ofType: FilmCardObject.self, forPrimaryKey: id)
        } catch {
            // Handle Realm errors
            print("Error reading film from Realm: \(error)")
            return nil
        }
    }
    
    private func requestFilmById(id: Int, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        guard let url = api.buildURL(for: .filmCard(id: id)) else {
            failure(APIError.invalidURL)
            return
        }
        
        requestJSON(url: url, success: { [weak self] json in
            // Update Realm with the fetched film data
            self?.updateRealmWithFilm(json: json)
            success()
        }, failure: { error in
            failure(error)
        })
    }
    
    private func updateRealmWithFilm(json: JSON) {
        do {
            let realm = try Realm()
            
            try realm.write {
                if let filmCadrDictionary = json["film"].dictionary,
                   let imagesDictionary = json["images"].dictionary {
                    
                    // Create a FilmCardObject using the fetched data
                    let filmObject = FilmCardObject(filmCadrDictionary: JSON(filmCadrDictionary),
                                                    imagesDictionary: JSON(imagesDictionary))
                    
                    // Add or update the film in Realm
                    realm.add(filmObject, update: .modified)
                }
            }
        } catch {
            // Handle Realm errors
            print("Error updating Realm with film: \(error)")
        }
    }
    
//    func getFilmFromRealm(at index: Int) -> FilmObject? {
//        do {
//            let realm = try Realm()
//            
//            // Assuming you have a primary key for FilmObject and the primary key is an integer
//            if let filmObject = realm.object(ofType: FilmObject.self, forPrimaryKey: index) {
//                return filmObject
//            } else {
//                // Handle the case where the filmObject is not found
//                print("FilmObject not found in Realm at index: \(index)")
//                return nil
//            }
//        } catch {
//            // Handle Realm errors
//            print("Error accessing Realm: \(error)")
//            return nil
//        }
//    }
    
    func getFilmFromRealm(at index: Int) -> FilmObject? {
        do {
            let realm = try Realm()

            // Assuming you have a primary key for FilmObject and the primary key is an integer
            let films = realm.objects(FilmObject.self).sorted(byKeyPath: "kinopoiskId", ascending: false)


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
}
