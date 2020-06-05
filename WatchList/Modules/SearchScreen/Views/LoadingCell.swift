import UIKit

class LoadingCell: UITableViewCell {
    
    // MARK: - Instance Properties
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: -
    
    var isLoading: Bool {
        get {
            return activityIndicator.isAnimating
        }
        
        set {
            //false
            newValue ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }
    }
}
