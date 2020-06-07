import UIKit
import PromiseKit

class SearchView: UIViewController {
    
    // MARK: - Nested Types
    
    private enum Constants {
        
        // MARK: - Type Properties
        
        static let SearchCellIdentifier = "SearchCell"
        static let SearchResultCellIdintidier = "SearchResultCell"
        static let LoadingCell = "LoadingCell"
    }
    
    // MARK: - Instance Properties
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var isLoading = false
    private var movies: [MovieInfo] = []
    
    // MARK: -
    
    var onMovieCellSelected: ((_ movie: MovieInfo) -> ())?
    
    // MARK: - Instance Methods
    
    private func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.tableFooterView = UIView(frame: CGRect(x: self.tableView.frame.origin.x,
                                                              y: self.tableView.frame.origin.y - 1,
                                                              width: self.tableView.frame.width,
                                                              height: 1))
    }
    
    // MARK: -
    
    private func configure(cell: SearchCell) {
        cell.selectionStyle = .none
        
        cell.onSearchButtonTouchUpInside = { searchText in
            
            self.isLoading = true
            self.tableView.reloadData()
            
            firstly {
                NetworkManager.shared.searchMovies(with: searchText)
            }.done { movies in
                self.movies = movies
            }.ensure {
                self.isLoading = false
                self.tableView.reloadData()
            }.catch { error in
                //TODO: -
            }
        }
    }
    
    private func configure(cell: SearchResultCell, with movieInfo: MovieInfo) {
        cell.ruNameText = movieInfo.ruName
        cell.engNameText = movieInfo.engName
    }
    
    private func configure(cell: LoadingCell) {
        cell.isLoading = self.isLoading
        cell.selectionStyle = .none
    }
    
    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTableView()
    }
}

// MARK: - UITableViewDataSource

extension SearchView: UITableViewDataSource {
    
    // MARK: - Instance Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.isLoading ? 3 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
            
        case 1:
            return self.movies.count
        
        case 2:
            return 1
            
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.SearchCellIdentifier) as! SearchCell
            self.configure(cell: cell)
            return cell
            
        case 1:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.SearchResultCellIdintidier) as! SearchResultCell
            self.configure(cell: cell, with: self.movies[indexPath.row])
            return cell
        
        case 2:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.LoadingCell) as! LoadingCell
            self.configure(cell: cell)
            return cell
            
        default:
            fatalError()
        }
    }
}

// MARK: - UITableViewDelegate

extension SearchView: UITableViewDelegate {
    
    // MARK: - Instance Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            let movie = self.movies[indexPath.row]
            self.onMovieCellSelected?(movie)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
