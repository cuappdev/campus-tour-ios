import UIKit

extension UITabBarItem {
    static var bookmarkItem: UITabBarItem { return UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0) }
    static var feedItem: UITabBarItem { return UITabBarItem(tabBarSystemItem: .featured, tag: 1)}
}
