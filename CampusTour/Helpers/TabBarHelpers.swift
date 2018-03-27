import UIKit

extension UITabBarItem {
    //TODO need to change this to map icon when designs are made
    static var poiMapItem: UITabBarItem { return UITabBarItem(tabBarSystemItem: UITabBarSystemItem.search, tag: 0) }
    static var feedItem: UITabBarItem { return UITabBarItem(tabBarSystemItem: .featured, tag: 1)}
}
