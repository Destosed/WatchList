import UIKit

class SearchResultCell: UITableViewCell {
    
    // MARK: - Instance Properties

    @IBOutlet private weak var ruNameLabel: UILabel!
    @IBOutlet private weak var engNameLabel: UILabel!
    
    // MARK: -
    
    var ruNameText: String? {
        get {
            return ruNameLabel.text
        }
        
        set {
            self.ruNameLabel.text = newValue
        }
    }
    
    var engNameText: String? {
        get {
            return engNameLabel.text
        }
        
        set {
            engNameLabel.text = newValue
        }
    }
}
