import CoreLocation
import UIKit

func campusTourNavigationViewController(root: UIViewController) -> UINavigationController {
    let nvc = UINavigationController(rootViewController: root)
    nvc.navigationBar.isTranslucent = false
    nvc.navigationBar.barTintColor = Colors.paleGrey
    return nvc
}

class MainTabBarController: UITabBarController {
    let feedVC = FeaturedViewController()
    let bookmarksVC = BookmarksViewController()
    
    override func viewDidLoad() {
        feedVC.delegate = self
        bookmarksVC.delegate = self
        let tabBarHeight = tabBar.frame.size.height
        feedVC.tabBarItem = .feedItem
        bookmarksVC.tabBarItem = .bookmarkItem
        feedVC.tabBarHeight = tabBarHeight
        setViewControllers([
            campusTourNavigationViewController(root: feedVC),
            campusTourNavigationViewController(root: bookmarksVC),
            ], animated: false)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if tabBar.items?.index(of: item) == 0 {
            let currVC = (feedVC.viewType == .List) ? feedVC.itemFeedViewController : feedVC.poiMapViewController
            if currVC == feedVC.itemFeedViewController {
                let tv = feedVC.itemFeedViewController.tableView
                tv.scrollToRow(at: IndexPath(row: 0,section: 0), at: UITableViewScrollPosition.top, animated: true)
            }
        }
    }
}

extension MainTabBarController: FeaturedViewControllerDelegate, BookmarksViewControllerDelegate {
    func didUpdateBookmarkFromBookmarkVC() {
        let tableView = feedVC.itemFeedViewController.tableView
        tableView.reloadData()
    }
    
    func didUpdateBookmarkFromFeaturedVC() {
        bookmarksVC.updateTableView()
    }
}
