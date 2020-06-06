import Foundation
import UIKit
import TextFieldEffects

class LoginView: UIViewController {
    
    // MARK: - Nested Types
    
    private enum Constants {
        
        // MARK: - Type Properties
        
        static let cornerRadius: CGFloat = 5.0
        
        static let loginButtonBottomConstraint: CGFloat = 20.0
    }
    
    // MARK: - Instance Properties
    
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var loginTextField: YoshikoTextField!
    @IBOutlet private weak var passwordTextField: YoshikoTextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var loginButtonBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Instance Methods
    
    @IBAction private func onGoToRegisterButtonTouchUpInside(_ sender: UIButton) {
    }
    
    @IBAction private func onLoginButtonTouchUpInside(_ sender: UIButton) {
    }
    
    // MARK: -
    
    @objc private func handle(keyboardWillShowNotification notification: Notification) {
        if let userInfo = notification.userInfo,
            let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardRectangle.height
            
            self.loginButtonBottomConstraint.constant = keyboardHeight + 15.0
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc private func handle(keyboardWillHideNotification notification: Notification) {
        self.loginButtonBottomConstraint.constant = Constants.loginButtonBottomConstraint
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @objc private func hideKeyboard() {
        self.loginTextField.endEditing(true)
        self.passwordTextField.endEditing(true)
    }
    
    // MARK: -
    
    private func subscribeForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handle(keyboardWillShowNotification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handle(keyboardWillHideNotification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func unSubscribeForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    // MARK: -
    
    private func configureInterface() {
        self.loginButton.layer.cornerRadius = Constants.cornerRadius
        
        self.loginTextField.layer.cornerRadius = Constants.cornerRadius
        self.loginTextField.activeBorderColor = Colors.mainColor
        self.loginTextField.inactiveBorderColor = .clear
        self.loginTextField.activeBackgroundColor = .clear
        self.loginTextField.placeholderFontScale = 0.7
        self.loginTextField.placeholderColor = .lightGray
        self.loginTextField.borderSize = 0
        
        self.passwordTextField.layer.cornerRadius = Constants.cornerRadius
        self.passwordTextField.activeBorderColor = Colors.mainColor
        self.passwordTextField.inactiveBorderColor = .clear
        self.passwordTextField.activeBackgroundColor = .clear
        self.passwordTextField.placeholderFontScale = 0.7
        self.passwordTextField.placeholderColor = .lightGray
        self.passwordTextField.borderSize = 0
        
        let viewTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        self.view.addGestureRecognizer(viewTapGesture)
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.subscribeForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.unSubscribeForKeyboardNotifications()
    }
}
