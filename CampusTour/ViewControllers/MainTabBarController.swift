import CoreLocation
import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        let searchVC = FeaturedViewController()
        let poiMapVC = POIMapViewController()
        searchVC.tabBarItem = UITabBarItem.feedItem
        poiMapVC.tabBarItem = UITabBarItem.poiMapItem
        setViewControllers([
            UINavigationController(rootViewController: searchVC),
            UINavigationController(rootViewController: poiMapVC),
            ], animated: false)
    }
}
