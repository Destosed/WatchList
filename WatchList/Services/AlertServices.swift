import Foundation
import UIKit

class AlertService {
    
    // MARK: - Instance Properties
    
    static let shared = AlertService()
    
    // MARK: - Instance Methods
    
    func showError(on vc: UIViewController, title: String?, message: String?, complition: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            complition?()
        })
        
        alertController.addAction(okAction)
        
        vc.present(alertController, animated: true, completion: nil)
    }
}
