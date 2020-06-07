import Foundation
import Kingfisher
import PromiseKit
import UIKit

class WatchedView: UIViewController, WatchedViewProtocol {
    
    // MARK: - Nested Types
    
    enum Constants {
        
        // MARK: - Type Properties
        
        static let mediaTypeCell = "MediaTypeCell"
        static let mediaItemCell = "MediaItemCell"
    }
    
    // MARK: - Instance Properties
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var refreshControl = UIRefreshControl()
    
    private var movies: [MovieInfo] = []
    private var filteredMovies: [MovieInfo] = []
    private var category: Category = .all {
        didSet {
            self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
            //TODO: - Add filtration
        }
    }
    
    // MARK: - Instance Methods
    
    // MARK: -
    
    @IBAction private func onMoreButtonTouchUpInside(_ sender: UIBarButtonItem) {
        self.presentMoreOptionsAlert()
    }
    
    // MARK: -
    
    private func presentMediaTypePicker() {
        let alertController = UIAlertController(title: "Media Type", message: nil, preferredStyle: .actionSheet)
        
        let allAction = UIAlertAction(title: Category.all.rawValue, style: .default, handler: { _ in
            self.category = .all
        })
        let filmAction = UIAlertAction(title: Category.film.rawValue, style: .default, handler: { _ in
            self.category = .film
        })
        let seriesAction = UIAlertAction(title: Category.series.rawValue, style: .default, handler: { _ in
            self.category = .series
        })
        let animeAction = UIAlertAction(title: Category.anime.rawValue, style: .default, handler: { _ in
            self.category = .anime
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(allAction)
        alertController.addAction(filmAction)
        alertController.addAction(seriesAction)
        alertController.addAction(animeAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func presentMoreOptionsAlert() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default, handler: { _ in
            let searchStoryboard = UIStoryboard(name: "Search", bundle: nil)
            
            guard let searchController = searchStoryboard.instantiateInitialViewController() as? SearchView else {
                return
            }
            
            searchController.onMovieCellSelected = { movie in
                firstly {
                    NetworkManager.shared.postMovie(movieID: movie.id!, note: " ", rating: 5, seen: true)
                }.done {
                    self.movies.append(movie)
                    self.tableView.reloadData()
                }.catch { error in
                    AlertService.shared.showError(on: self,
                                                  title: "Error",
                                                  message: error.localizedDescription,
                                                  complition: nil)
                }
            }
            
            self.present(searchController, animated: true, completion: nil)
        })
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: -
    
    private func fetchMovies() {
        self.refreshControl.beginRefreshing()
        
        firstly {
            NetworkManager.shared.getMovies(category: .all, filterType: .watched)
        }.done { movies in
            self.movies = movies
        }.ensure {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }.catch { error in
            AlertService.shared.showError(on: self, title: "Error", message: error.localizedDescription, complition: nil)
        }
    }
    
    // MARK: -
    
    private func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let nibMediaTypeCell = UINib(nibName: Constants.mediaTypeCell, bundle: nil)
        self.tableView.register(nibMediaTypeCell, forCellReuseIdentifier: Constants.mediaTypeCell)
        
        let nibMediaItemCell = UINib(nibName: Constants.mediaItemCell, bundle: nil)
        self.tableView.register(nibMediaItemCell, forCellReuseIdentifier: Constants.mediaItemCell)
        
        self.tableView.separatorStyle = .none
    }
    
    private func configureMediaTypeCell(cell: MediaTypeCell) {
        cell.selectionStyle = .none
        cell.category = self.category
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
    
    // MARK: -
    
    @objc func startRefreshing() {
        self.fetchMovies()
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTableView()
        self.refreshControl.addTarget(self, action: #selector(self.startRefreshing), for: .valueChanged)
        self.tableView.refreshControl = self.refreshControl
        
        self.fetchMovies()
    }
}

// MARK: - UITableViewDataSource

extension WatchedView: UITableViewDataSource {
    
    // MARK: - Instance Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return self.movies.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.mediaTypeCell) as! MediaTypeCell
            self.configureMediaTypeCell(cell: cell)
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.mediaItemCell) as! MediaItemCell
            self.configureMediaItemCell(cell: cell, with: self.movies[indexPath.row])
            return cell
            
        default:
            fatalError()
        }
    }
}

// MARK: - UITableViewDelegate

extension WatchedView: UITableViewDelegate {
    
    // MARK: - Instance Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 70.0
            
        default:
            return 170.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            self.presentMediaTypePicker()
            
        default:
            return
        }
    }
}
