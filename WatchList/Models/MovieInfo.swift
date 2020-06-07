import Foundation
import Gloss

struct MovieInfo {
    
    // MARK: - Nested Types
    
    private enum Keys {
        
        // MARK: - Enumeration Cases
        
        static let ruName = "nameRu"
    }
    
    // MARK: - Type Properties
    
    let id: Int?
    let ruName: String?
    let engName: String?
    let year: String?
    let description: String?
    let filmLength: String?
    let rating: Double?
    let genres: [String]?
    let posterURL: String?
    
    // MARK: - Initializators
    
    init(json: JSON) {
        self.id = "id" <~~ json
        self.ruName = "nameRu" <~~ json
        self.engName = "nameEn" <~~ json
        self.year = "year" <~~ json
        self.description = "description" <~~ json
        self.filmLength = "filmLength" <~~ json
        self.rating = "rating" <~~ json
        self.posterURL = "posterUrl" <~~ json
        
        self.genres = {
            var genresToReturn: [String] = []
            
            guard let genresJSON: [JSON] = "genres" <~~ json else {
                return []
            }
            
            for genreJSON in genresJSON {
                if let genre: String = "genre" <~~ genreJSON {
                    genresToReturn.append(genre)
                }
            }
            
            return genresToReturn
        }()
    }
}
