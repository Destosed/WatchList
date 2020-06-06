import Foundation
import TextFieldEffects
import PromiseKit
import UIKit

class RegisterView: UIViewController {
    
    // MARK: - Nested Types
    
    private enum Constants {
        
        // MARK: - Type Properties
        
        static let cornerRadius: CGFloat = 5.0
        
        static let loginButtonBottomConstraint: CGFloat = 20.0
    }
    
    // MARK: - Instance Properties
    
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var loginTextField: YoshikoTextField!
    @IBOutlet private weak var emailTextField: YoshikoTextField!
    @IBOutlet private weak var passwordTextField: YoshikoTextField!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var loginButtonBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Instance Methods
    
    @IBAction private func onGoToLoginButtonTouchUpInside(_ sender: UIButton) {
        let authStoryboard = UIStoryboard(name: "Authorization", bundle: nil)
        let loginView = authStoryboard.instantiateViewController(identifier: "LoginView") as! LoginView
        UIApplication.setRootView(loginView)
    }
    
    @IBAction private func onRegisterButtonTouchUpInside(_ sender: UIButton) {
        guard let login = self.loginTextField.text,
            let password = self.passwordTextField.text,
            let email = self.emailTextField.text else {
            return
        }
        
        firstly {
            NetworkManager.shared.registerUser(login: login, email: email, password: password)
        }.then {
            NetworkManager.shared.authorizeUser(login: login, password: password)
        }.done {
            self.navigateToWatchedView()
        }.catch { error in
            AlertService.shared.showError(on: self,
                                          title: "Error",
                                          message: error.localizedDescription,
                                          complition: nil)
        }
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
        self.emailTextField.endEditing(true)
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
        self.registerButton.layer.cornerRadius = Constants.cornerRadius
        
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
        
        self.emailTextField.layer.cornerRadius = Constants.cornerRadius
        self.emailTextField.activeBorderColor = Colors.mainColor
        self.emailTextField.inactiveBorderColor = .clear
        self.emailTextField.activeBackgroundColor = .clear
        self.emailTextField.placeholderFontScale = 0.7
        self.emailTextField.placeholderColor = .lightGray
        self.emailTextField.borderSize = 0
        
        let viewTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        self.view.addGestureRecognizer(viewTapGesture)
    }
    
    private func navigateToWatchedView() {
        let mainTabbarStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabbarController = mainTabbarStoryboard.instantiateInitialViewController() as! MainTabbarController
        UIApplication.setRootView(tabbarController)
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
