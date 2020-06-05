import Foundation
import Alamofire
import Gloss
import PromiseKit

class MovieNetworkManager {
    
    // Insstance Properties
    
    static let shared = MovieNetworkManager()
    
    // MARK: -
    
    private let baseURL = "http://kinopoiskapiunofficial.tech/api/v2.1/films/search-by-keyword"
    private let token = "8amICCoTyAaVgu9yHVz58RnmSa6BO5l7"
    
    // MARK: - Instance Methods
    
    func getMovies(with keyword: String) -> Promise<[MovieInfo]> {
        let headers = ["accept": "application/json",
                       "X-API-KEY": self.token]
        
        let parameters = ["keyword" : keyword]
        
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
                    guard let moviesArrayJSON: [JSON] = "films" <~~ json else {
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
