import UIKit
import Kingfisher
import PromiseKit

class RecomendationsView: UIViewController {
    
    // MARK: - Nested Types
    
    enum Constants {
        
        // MARK: - Type Properties
        
        static let mediaItemCell = "MediaItemCell"
    }
    
    // MARK: - Instance Properties

    @IBOutlet private weak var tableView: UITableView!
    
    var movies: [MovieInfo] = []
    
    // MARK: - Insatnce Methods
    
    @IBAction private func onMoreButtonTouchUpInside(_ sender: Any) {
        self.presentMoreOptionsAlert()
    }
    
    // MARK: -
    
    private func fetchMovies() {
        firstly {
            NetworkManager.shared.getRecomendationMovies()
        }.done { movies in
            self.movies = movies
        }.ensure {
            self.tableView.reloadData()
        }.catch { error in
            AlertService.shared.showError(on: self,
                                          title: "Error",
                                          message: error.localizedDescription,
                                          complition: nil)
        }
    }
    
    private func presentMoreOptionsAlert() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let filterAction = UIAlertAction(title: "Filter", style: .default, handler: { [weak self] _ in
            
            let filterAlertController = UIAlertController(title: "Filter By", message: nil, preferredStyle: .actionSheet)
            let byRatingAction = UIAlertAction(title: "By Rating", style: .default, handler: { _ in
            })
            let byAlphabetAction = UIAlertAction(title: "By Alphabet", style: .default, handler: { _ in
            })
            
            filterAlertController.addAction(byRatingAction)
            filterAlertController.addAction(byAlphabetAction)
            filterAlertController.addAction(cancelAction)

            self?.present(filterAlertController, animated: true, completion: nil)
        })
        
        alertController.addAction(filterAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: -
    
    private func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let nibMediaItemCell = UINib(nibName: Constants.mediaItemCell, bundle: nil)
        self.tableView.register(nibMediaItemCell, forCellReuseIdentifier: Constants.mediaItemCell)
        
        self.tableView.separatorStyle = .none
    }
    
    private func configureMediaItemCell(cell: MediaItemCell, with movie: MovieInfo) {
        cell.selectionStyle = .none
        
        cell.title = movie.ruName
        cell.subTitle = movie.engName
        cell.note = movie.description
        
        if let intRating = Int(movie.rating ?? "") {
            cell.rating = Double(intRating)
        }
        
        if let imageURL = URL(string: movie.posterURL ?? "") {
            let resource = ImageResource(downloadURL: imageURL,
                                         cacheKey: movie.posterURL)
            cell.imageViewTarget.kf.setImage(with: resource)
        }
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTableView()
        self.fetchMovies()
    }
}

// MARK: - UITableViewDataSource

extension RecomendationsView: UITableViewDataSource {
    
    // MARK: - Instance Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.mediaItemCell) as! MediaItemCell
        self.configureMediaItemCell(cell: cell, with: self.movies[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension RecomendationsView: UITableViewDelegate {
    
    // MARK: - Instance Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170.0
    }
}
