//
//  SceneDelegate.swift
//  WatchList
//
//  Created by Никита Лужбин on 24.02.2020.
//  Copyright © 2020 Никита. All rights reserved.
//

import UIKit
import PromiseKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        if let user = UserDefaultsManager.shared.getUser() {
            firstly {
                NetworkManager.shared.authorizeUser(login: user.login, password: user.password)
            }.done {
                let mainTabbarStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let tabbarController = mainTabbarStoryboard.instantiateInitialViewController() as! MainTabbarController
                self.window?.rootViewController = tabbarController
            }
            
        } else {
            let authStoryboard = UIStoryboard(name: "Authorization", bundle: nil)
            let loginView = authStoryboard.instantiateInitialViewController() as! LoginView
            self.window?.rootViewController = loginView
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

