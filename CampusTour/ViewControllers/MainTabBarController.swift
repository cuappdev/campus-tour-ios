import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        setViewControllers([
            UINavigationController(rootViewController: POIMapViewController()),
            ItemFeedViewController()
            ], animated: false)
    }
}
