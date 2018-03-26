import CoreLocation
import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        let arVc = ARExplorerViewController()
        
        do {
            let parsed = try ParseData()
            arVc.itemsOfInterest = parsed.locations.map { ARItemOfInterest(
                name: $0.name,
                location: CLLocation(
                    latitude: CLLocationDegrees($0.latitude),
                    longitude: CLLocationDegrees($0.longitude)))
            }
            print("init arVc parsed items with count: \(arVc.itemsOfInterest.count)")
        } catch let e {
            print(e)
        }

        let searchVC = SearchViewController()
        let poiMapVC = POIMapViewController()
        searchVC.tabBarItem = UITabBarItem.feedItem
        poiMapVC.tabBarItem = UITabBarItem.poiMapItem
        setViewControllers([
            UINavigationController(rootViewController: searchVC),
            UINavigationController(rootViewController: poiMapVC),
            arVc
            ], animated: false)
    }
}
