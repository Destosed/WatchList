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
                    
                    if let json = result as? JSON, let token: String = "token" <~~ json {
                        self.token = token
                    }
                    seal.fulfill(())
                }
            }
        }
    }
    
    //MARK: -
    
    func getMovies(with keyword: String) -> Promise<[MovieInfo]> {
        let baseURL = "https://watchlist.procrastineyaz.dev/api/kinopoisk/search"
        
        var headers: HTTPHeaders = ["accept": "application/json"]
        if let token = self.token {
            headers["Authorization"] = "Bearer \(token)"
        }
        
        let parameters = ["keywords" : keyword]
        
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
    
    func getRecomendationMovies() -> Promise<[MovieInfo]> {
        let baseURL = ""
        
        var headers: HTTPHeaders = ["accept": "application/json"]
        if let token = self.token {
            headers["Authorization"] = "Bearer \(token)"
        }
        
        let parameters: Parameters = [:]
        
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
}
