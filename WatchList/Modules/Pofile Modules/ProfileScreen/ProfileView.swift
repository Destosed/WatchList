//
//  ProfileView.swift
//  WatchList
//
//  Created by Никита Лужбин on 05.06.2020.
//  Copyright © 2020 Никита. All rights reserved.
//

import UIKit

class ProfileView: UIViewController {
    
    // MARK: - Nested Types
    
    private enum Constants {
        
        // MARK: - Type Properties
        
        static let cornerRadius: CGFloat = 10.0
    }
    
    // MARK: - Instance Properties

    @IBOutlet weak var nestedContentView: UIView!
    
    @IBOutlet weak var roundedTopView: UIView!
    @IBOutlet weak var profileImageView: UIView!
    @IBOutlet weak var userInitialsLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    @IBOutlet weak var watchedAmountLabel: UILabel!
    @IBOutlet weak var wishListAmountLabel: UILabel!
    @IBOutlet weak var friendsAmountLabel: UILabel!
    
    // MARK: - Instance Methods
    
    @IBAction func onLogoutButtonTouchUpInside(_ sender: UIBarButtonItem) {
        UserDefaultsManager.shared.deleteUser()
        let authStoryboard = UIStoryboard(name: "Authorization", bundle: nil)
        let loginView = authStoryboard.instantiateInitialViewController() as! LoginView
        UIApplication.setRootView(loginView)
    }
    
    private func configureInterface() {
        self.nestedContentView.layer.cornerRadius = Constants.cornerRadius
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.layer.frame.height / 2
        self.roundedTopView.layer.cornerRadius = self.roundedTopView.layer.frame.height / 2
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureInterface()
    }
}
