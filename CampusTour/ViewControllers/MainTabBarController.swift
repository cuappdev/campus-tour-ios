import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        setViewControllers([
            UINavigationController(rootViewController: POIMapViewController()),
            UINavigationController(rootViewController: SearchViewController())
            ], animated: false)
    }
}
