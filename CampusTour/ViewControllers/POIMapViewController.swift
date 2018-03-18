import UIKit
import GoogleMaps

struct POI {
    let coords: CLLocationCoordinate2D
}

class POIMapViewController: UIViewController {
    
    var locationListener: LocationProvider.LocationListener?
    
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
        
        //when location becomes available, set map to location
        locationListener = { [weak self] (location: CLLocation) in
            print("got location")
            self?.mapView.moveCamera(GMSCameraUpdate.setTarget(location.coordinate))
            self?.locationListener = nil
        }
        AppDelegate.shared?.locationProvider.addLocationListener(repeats: false, listener: locationListener!)
        
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
