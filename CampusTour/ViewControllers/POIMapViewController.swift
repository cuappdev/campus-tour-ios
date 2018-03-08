import UIKit
import GoogleMaps

struct POI {
    let coords: CLLocationCoordinate2D
}

class POIMapViewController: UIViewController {
    
    var mapView: GMSMapView {
        get {return view as! GMSMapView}
        set {view = newValue}
    }
    
    var pois: [POI] = []
    
    convenience init(pois: [POI]) {
        self.init()
        self.pois = pois
    }
    
    override func loadView() {
        let currentLocation = (try? AppDelegate.shared!.locationProvider.getLocation()) ??
            CLLocation(latitude: 0.0, longitude: 0.0)
        let cameraPos = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude,
                                                 longitude: currentLocation.coordinate.longitude, zoom: 15.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: cameraPos)
        
        pois.forEach { poi in
            let marker = GMSMarker(position: poi.coords)
            marker.title = "TODO add title."
            marker.map = mapView
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem = UITabBarItem.poiMapItem
    }
}
