import Foundation
import Alamofire
import Gloss
import PromiseKit

class NetworkManager {
    
    // Insstance Properties
    
    static let shared = NetworkManager()
    
    // MARK: -
    
    private var token: String?
    
    // MARK: - Instance Methods
    
    func registerUser(login: String, email: String, password: String) -> Promise<Void> {
        let baseURL = "https://watchlist.procrastineyaz.dev/api/users"
        let headers: HTTPHeaders = ["accept": "application/json"]
        let parameters: Parameters = ["username" : login,
                                      "email" : email,
                                      "password": password]
        
        return Promise<Void> { seal in
            Alamofire.request(baseURL, method: .post, parameters: parameters, headers: headers).validate().responseJSON { response in
                
                switch response.result {
                case .failure(let error):
                    seal.reject(error)
                    
                case .success:
                    seal.fulfill(())
                }
            }
        }
    }
    
    func authorizeUser(login: String, password: String) -> Promise<Void> {
        let baseURL = "https://watchlist.procrastineyaz.dev/api/users/login"
        let headers: HTTPHeaders = ["accept": "application/json"]
        let parameters: Parameters = ["username": login,
                                      "password": password]

        return Promise<Void> { seal in
            Alamofire.request(baseURL,
                              method: .post,
                              parameters: parameters, headers: headers).validate().responseJSON { response in
                
                switch response.result {
                case .failure(let error):
                    seal.reject(error)
                    
                case .success(let result):
                    UserDefaultsManager.shared.saveUser(user: User(login: login, password: password))
                    
                    if let json = result as? JSON, let token: String = "token" <~~ json {
                        self.token = token
                    }
                    seal.fulfill(())
                }
            }
        }
    }
    
    //MARK: -
    
    func searchMovies(with keyword: String) -> Promise<[MovieInfo]> {
        let baseURL = "https://watchlist.procrastineyaz.dev/api/kinopoisk/search"
        let parameters = ["keywords" : keyword]
        let headers: HTTPHeaders = ["accept": "application/json",
                                    "Authorization": "Bearer \(self.token ?? "")"]
        
        return Promise<[MovieInfo]> { seal in
            Alamofire.request(baseURL, method: .get, parameters: parameters, headers: headers).responseJSON { response in
                
                switch response.result {
                case .failure(let error):
                    seal.reject(error)
                    
                case .success(let result):
                    guard let json = result as? JSON else {
                        //TODO: - Нормально обработать
                        fatalError()
                    }
                    guard let moviesArrayJSON: [JSON] = "items" <~~ json else {
                        fatalError()
                    }
                    
                    var movies: [MovieInfo] = []
                    
                    for movieJSON in moviesArrayJSON {
                        let movieInfo = MovieInfo(json: movieJSON)
                        movies.append(movieInfo)
                    }
                    
                    seal.fulfill(movies)
                }
            }
        }
    }
    
    func getMovies(category: Category, filterType: FilterType,
                   searchString: String? = nil, page: Int = 1, itemsPerPage: Int = 100) -> Promise<[MovieInfo]> {
        
        let baseURL = "https://watchlist.procrastineyaz.dev/api/items"
        
        let parameters: Parameters = ["category": category.rawValue,
                                      "filter": filterType.rawValue,
                                      "page": page,
                                      "itemsPerPage": itemsPerPage]
        
        let headers: HTTPHeaders = ["accept": "application/json",
                                    "Authorization": "Bearer \(self.token ?? "")"]
        
        return Promise<[MovieInfo]> { seal in
            Alamofire.request(baseURL, method: .get, parameters: parameters, headers: headers).validate().responseJSON { response in
                
                switch response.result {
                case .failure(let error):
                    seal.reject(error)
                    
                case .success(let result):
                    guard let json = result as? JSON else {
                        //TODO: - Нормально обработать
                        fatalError()
                    }
                    guard let moviesArrayJSON: [JSON] = "items" <~~ json else {
                        fatalError()
                    }
                    
                    var movies: [MovieInfo] = []
                    
                    for movieJSON in moviesArrayJSON {
                        let movieInfo = MovieInfo(json: movieJSON)
                        movies.append(movieInfo)
                    }
                    
                    seal.fulfill(movies)
                }
            }
        }
    }
    
    func getRecomendationMovies() -> Promise<[MovieInfo]> {
        let baseURL = "https://watchlist.procrastineyaz.dev/api/recommendations"
        
        let headers: HTTPHeaders = ["accept": "application/json",
                                    "Authorization": "Bearer \(self.token ?? "")"]
        
        return Promise<[MovieInfo]> { seal in
            Alamofire.request(baseURL, method: .get, headers: headers).validate().responseJSON { response in
                
                switch response.result {
                case .failure(let error):
                    seal.reject(error)
                    
                case .success(let result):
                    guard let json = result as? JSON else {
                        //TODO: - Нормально обработать
                        fatalError()
                    }
                    guard let moviesArrayJSON: [JSON] = "rows" <~~ json else {
                        fatalError()
                    }
                    
                    var movies: [MovieInfo] = []
                    
                    for movieJSON in moviesArrayJSON {
                        let movieInfo = MovieInfo(json: movieJSON)
                        movies.append(movieInfo)
                    }
                    
                    seal.fulfill(movies)
                }
            }
        }
    }
    
    func postMovie(movieID: Int, note: String? = nil, rating: Int? = nil, seen: Bool) -> Promise<Void> {
        let baseURL = "https://watchlist.procrastineyaz.dev/api/items"
        
        var parameters: Parameters = ["itemId": movieID,
                                      "seen": seen]
        if let rating = rating {
            parameters["rating"] = rating
        }
        if let note = note {
            parameters["note"] = note
        }
        
        let headers: HTTPHeaders = ["accept": "application/json",
                                    "Authorization": "Bearer \(self.token ?? "")"]
        
        return Promise<Void> { seal in
            Alamofire.request(baseURL, method: .post, parameters: parameters, headers: headers).validate().responseJSON { response in
                
                switch response.result {
                case .failure(let error):
                    seal.reject(error)
                    
                case .success:
                    seal.fulfill(())
                }
            }
        }
    }
}
