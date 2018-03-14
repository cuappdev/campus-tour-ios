import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        setViewControllers([
            UINavigationController(rootViewController: POIMapViewController())
            ], animated: false)
    }
}
