import CoreLocation
import UIKit

func campusTourNavigationViewController(root: UIViewController) -> UINavigationController {
    let nvc = UINavigationController(rootViewController: root)
    nvc.navigationBar.isTranslucent = false
    nvc.navigationBar.barTintColor = Colors.opaqueShadow
    return nvc
}

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        let searchVC = FeaturedViewController()
        let poiMapVC = POIMapViewController()
        searchVC.tabBarItem = UITabBarItem.feedItem
        poiMapVC.tabBarItem = UITabBarItem.poiMapItem
        setViewControllers([
            campusTourNavigationViewController(root: searchVC),
            campusTourNavigationViewController(root: poiMapVC),
            ], animated: false)
    }
}
