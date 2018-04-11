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
        let feedVC = FeaturedViewController()
        let bookmarksVC = BookmarksViewController()
        let tabBarHeight = tabBar.frame.size.height
        feedVC.tabBarItem = .feedItem
        bookmarksVC.tabBarItem = .bookmarkItem
        feedVC.tabBarHeight = tabBarHeight
        setViewControllers([
            campusTourNavigationViewController(root: feedVC),
            campusTourNavigationViewController(root: bookmarksVC),
            ], animated: false)
    }
}
