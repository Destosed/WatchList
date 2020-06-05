import UIKit

class MainTabbarController: UITabBarController {
    
    // MARK: - Neted Types

    enum TabBarItemType: Int {
        
        // MARK: - Enumeration Cases
        
        case watched = 0
        case wishList = 1
        case recomendations = 2
        case profile = 3
    }
    
    // MARK: - Instance Properties
    
    private let watchedIcon = UIImage(named: "Tabbar-Home-Icon")
    private let wishListIcon = UIImage(named: "Tabbar-Home-Icon")
    private let recomendationsIcon = UIImage(named: "Tabbar-Home-Icon")
    private let profileIcon = UIImage(named: "Tabbar-Home-Icon")
    
    // MARK: - Instance Methods
    
    private func initViewControllers() {
        let watchedStoryboard = UIStoryboard(name: "Watched", bundle: nil)
        let watchedNavController = watchedStoryboard.instantiateInitialViewController() as? UINavigationController
        let watchedView = watchedNavController?.viewControllers.first
        let watchedTabbarItem = UITabBarItem(title: "Watched", image: watchedIcon, tag: TabBarItemType.watched.rawValue)
        watchedView?.tabBarItem = watchedTabbarItem
        
        let wishListStoryboard = UIStoryboard(name: "WishList", bundle: nil)
        let wishListNavController = wishListStoryboard.instantiateInitialViewController() as? UINavigationController
        let wishListView = wishListNavController?.viewControllers.first
        let wishListTabbarItem = UITabBarItem(title: "WishList", image: wishListIcon, tag: TabBarItemType.watched.rawValue)
        wishListView?.tabBarItem = wishListTabbarItem
        
        let recomendationsStoryboard = UIStoryboard(name: "Recomendations", bundle: nil)
        let recomendationsNavController = recomendationsStoryboard.instantiateInitialViewController() as? UINavigationController
        let recomendationsView = recomendationsNavController?.viewControllers.first
        let recomendationsTabbarItem = UITabBarItem(title: "Recomendations", image: recomendationsIcon, tag: TabBarItemType.recomendations.rawValue)
        recomendationsView?.tabBarItem = recomendationsTabbarItem
        
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileNavController = profileStoryboard.instantiateInitialViewController() as? UINavigationController
        let profileView = profileNavController?.viewControllers.first
        let profileTabbarItem = UITabBarItem(title: "Profile", image: profileIcon, tag: TabBarItemType.profile.rawValue)
        profileView?.tabBarItem = profileTabbarItem
        
        let viewControllers = [ watchedNavController,
                                wishListNavController,
                                recomendationsNavController,
                                profileNavController ]
        
        self.viewControllers = viewControllers.map({$0 as! UIViewController})
    }
    
    //MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = .black
        
        initViewControllers()
    }
}
