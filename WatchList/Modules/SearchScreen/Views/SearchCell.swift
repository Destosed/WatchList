import UIKit

class SearchCell: UITableViewCell {
    
    // MARK: - Instance Properties

    @IBOutlet private weak var searchTextField: UITextField!
    
    // MARK: -
    
    var onSearchButtonTouchUpInside: ((_ searchText: String) -> ())?

    // MARK: - Instance Methods
    
    @IBAction private func onSearchButtonTouchUpInside(_ sender: UIButton) {
        guard let searchText = searchTextField.text else {
            return
        }
        
        self.onSearchButtonTouchUpInside?(searchText)
    }
}
