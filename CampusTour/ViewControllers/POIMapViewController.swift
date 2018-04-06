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
    
    var markers: [GMSMarker] = []
    
    override func loadView() {
        // TODO: Uncomment when testing on campus
//        let currentLocation = (try? AppDelegate.shared!.locationProvider.getLocation()) ??
//            CLLocation(latitude: 0.0, longitude: 0.0)
//        let cameraPos = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude,
//                                                 longitude: currentLocation.coordinate.longitude, zoom:
//
//        //when location becomes available, set map to location
//        locationListener = { [weak self] (location: CLLocation) in
//            print("got location")
//            self?.mapView.moveCamera(GMSCameraUpdate.setTarget(location.coordinate))
//            self?.locationListener = nil
//        }
//        AppDelegate.shared?.locationProvider.addLocationListener(repeats: false, listener: locationListener!)
        
        // For testing: Cornell Store location
        let cameraPos = GMSCameraPosition.camera(withLatitude: 42.447699, longitude: -76.484617, zoom: 12.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: cameraPos)
        
        testEvents.forEach { event in
            let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(event.location.lat), longitude: CLLocationDegrees(event.location.lng))
            let marker = GMSMarker(position: location)
            marker.userData = event
            marker.iconView = EventMarker()
            marker.map = mapView
            markers.append(marker)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
