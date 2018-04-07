import CoreLocation
import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        let searchVC = SearchViewController()
        let poiMapVC = POIMapViewController()
        let tabBarHeight = self.tabBar.frame.size.height
        searchVC.tabBarItem = UITabBarItem.feedItem
        poiMapVC.tabBarItem = UITabBarItem.poiMapItem
        poiMapVC.tabBarHeight = tabBarHeight
        setViewControllers([
            UINavigationController(rootViewController: searchVC),
            UINavigationController(rootViewController: poiMapVC),
            ], animated: false)
    }
}
