import CoreLocation
import UIKit

func campusTourNavigationViewController(root: UIViewController) -> UINavigationController {
    let nvc = UINavigationController(rootViewController: root)
    nvc.navigationBar.isTranslucent = false
    nvc.navigationBar.barTintColor = Colors.paleGrey
    return nvc
}

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        let searchVC = FeaturedViewController()
        let poiMapVC = POIMapViewController()
        let tabBarHeight = self.tabBar.frame.size.height
        searchVC.tabBarItem = UITabBarItem.feedItem
        poiMapVC.tabBarItem = UITabBarItem.poiMapItem
        poiMapVC.tabBarHeight = tabBarHeight
        setViewControllers([
            campusTourNavigationViewController(root: searchVC),
            campusTourNavigationViewController(root: poiMapVC),
            ], animated: false)
    }
}
