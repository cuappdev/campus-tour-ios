import UIKit

class MainTabBarController: UITabBarController {
    // empty parameter required to avoid infinite recursion. we should find a better solution for this.
    convenience init(_: ()) {
        self.init()
        setViewControllers([
            UINavigationController(rootViewController: POIMapViewController())
            ], animated: false)
    }
}
