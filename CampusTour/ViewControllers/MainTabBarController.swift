import CoreLocation
import UIKit

func campusTourNavigationViewController(root: UIViewController) -> UINavigationController {
    let nvc = UINavigationController(rootViewController: root)
    nvc.navigationBar.isTranslucent = false
    nvc.navigationBar.barTintColor = Colors.paleGrey
    return nvc
}

class MainTabBarController: UITabBarController {
    let searchVC = FeaturedViewController()
    let poiMapVC = POIMapViewController()
    
    override func viewDidLoad() {
        let tabBarHeight = self.tabBar.frame.size.height
        searchVC.tabBarItem = UITabBarItem.feedItem
        poiMapVC.tabBarItem = UITabBarItem.poiMapItem
        poiMapVC.tabBarHeight = tabBarHeight
        setViewControllers([
            campusTourNavigationViewController(root: searchVC),
            campusTourNavigationViewController(root: poiMapVC),
            ], animated: false)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if tabBar.items?.index(of: item) == 0 {
            let currVC = (searchVC.viewType == .List) ? searchVC.itemFeedViewController : searchVC.poiMapViewController
            if currVC == searchVC.itemFeedViewController {
                let tv = searchVC.itemFeedViewController.tableView
                tv.scrollToRow(at: IndexPath(row: 0,section: 0), at: UITableViewScrollPosition.top, animated: true)
            }
        }
    }
}
