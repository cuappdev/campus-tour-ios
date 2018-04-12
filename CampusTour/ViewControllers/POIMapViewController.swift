import UIKit
import MapKit
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
    var events: [Event] = []
    
    convenience init(pois: [POI]) {
        self.init()
        self.pois = pois
    }
    
    var markers: [String:(Int,GMSMarker)] = [:]
    var selectedEvent: Event?
    
    // Popup
    let popupHeight: CGFloat = 160
    let headerHeight: CGFloat = 40
    let edgePadding: CGFloat = 12
    let buttonWidth: CGFloat = 15
    var popupView = UIView()
    var popupTableView: UITableView?
    var tabBarHeight: CGFloat = 49
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
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
        let cameraPos = GMSCameraPosition.camera(withLatitude: 42.447699, longitude: -76.484617, zoom: 15.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: cameraPos)
        mapView.delegate = self
        
        updateEventMarkers(events: DataManager.sharedInstance.events)
    }
    
    func updateEventMarkers(events: [Event]) {
        // TODO: show only events for today
        self.events = Array(events.prefix(upTo: min(5, events.count)))
        mapView.clear()
        markers = [:]
        
        for (idx, event) in self.events.enumerated() {
            let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(event.location.lat), longitude: CLLocationDegrees(event.location.lng))
            let marker = GMSMarker(position: location)
            marker.userData = event
            marker.iconView = EventMarker(markerText: String(idx+1))
            marker.zIndex = Int32(idx)
            marker.map = mapView
            markers[event.id] = (idx, marker)
        }
    }
    
    // MARK: Popup View Functions
    
    func didSelectMarker(marker: GMSMarker) {
        let newEvent = marker.userData as! Event
        
        if let event = selectedEvent {
            dismissPopupView(newEvent: newEvent, fullyDismissed: event.id == newEvent.id, completionHandler: { _ in })
        } else {
            displayPopupView(event: newEvent)
        }
    }
    
    func createPopupView() {
        popupView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: popupHeight)
        popupView.backgroundColor = .white
        
        popupTableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: popupHeight))
        popupTableView!.delegate = self
        popupTableView!.dataSource = self
        popupTableView!.register(ItemOfInterestTableViewCell.self, forCellReuseIdentifier: ItemOfInterestTableViewCell.reuseIdEvent)
        popupTableView!.isScrollEnabled = false
        popupTableView!.separatorStyle = .none
        
        popupView.addSubview(popupTableView!)
        view.addSubview(popupView)
    }
    
    func animateMarker(marker: GMSMarker, select: Bool) {
        let iconView = marker.iconView as! EventMarker
        UIButton.animate(withDuration: 0.1, animations: {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            
            iconView.setSelected(selected: select)
            
            CATransaction.commit()
        })
    }
    
    func displayPopupView(event: Event) {
        let marker: GMSMarker = markers[event.id]!.1
        selectedEvent = event
        createPopupView()
        
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.popupView.frame.origin.y = self.view.frame.height - self.tabBarHeight - self.popupHeight
            self.animateMarker(marker: marker, select: true)
        }, completion: { _ in })
    }
    
    func dismissPopupView(newEvent: Event, fullyDismissed: Bool, completionHandler: @escaping (Bool) -> ()) {
        let selectedMarker: GMSMarker = markers[selectedEvent!.id]!.1
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
            self.popupView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.popupHeight)
            self.animateMarker(marker: selectedMarker, select: false)
        }, completion: { finished in
            self.popupView.subviews.forEach({$0.removeFromSuperview()})
            self.popupView.removeFromSuperview()

            if fullyDismissed {
                self.selectedEvent = nil
            } else {
                self.displayPopupView(event: newEvent)
            }

            completionHandler(finished)
        })
    }
    
    @objc func directionsButtonPressed(_ sender: UIButton) {
        showDirectionsPopupView(event: selectedEvent!)
    }
    
    @objc func dismissButtonPressed(_ sender: UIButton) {
        dismissPopupView(newEvent: selectedEvent!, fullyDismissed: true, completionHandler: { _ in })
    }

}

//MARK: Tableview protocols
extension POIMapViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemOfInterestTableViewCell.reuseIdEvent) as! ItemOfInterestTableViewCell
        let idx: Int = markers[selectedEvent!.id]!.0 + 1
        
        cell.setCellModel(model: selectedEvent!.toItemFeedModelInfo(index: idx))
    
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

}

extension POIMapViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: headerHeight))
        
        let directionsButton = UIButton()
        directionsButton.setTitle("Directions", for: .normal)
        directionsButton.setTitleColor(Colors.systemBlue, for: .normal)
        directionsButton.titleLabel?.font = Fonts.bodyFont
        directionsButton.contentHorizontalAlignment = .trailing
        directionsButton.addTarget(self, action: #selector(self.directionsButtonPressed(_:)), for: .touchUpInside)
        directionsButton.sizeToFit()
        
        let dismissButton = UIButton()
        dismissButton.setImage(#imageLiteral(resourceName: "ExitIcon"), for: .normal)
        dismissButton.addTarget(self, action: #selector(self.dismissButtonPressed(_:)), for: .touchUpInside)
        
        let lineView = UIView()
        lineView.backgroundColor = Colors.shadow
        
        headerView.addSubview(directionsButton)
        headerView.addSubview(dismissButton)
        headerView.addSubview(lineView)

        directionsButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(edgePadding)
            make.centerY.equalTo(headerView.snp.centerY)
        }
        
        dismissButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-edgePadding)
            make.centerY.equalTo(headerView.snp.centerY)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonWidth)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let detailVC: DetailViewController = {
            let vc = DetailViewController()
            vc.event = selectedEvent
            vc.title = selectedEvent!.name
            return vc
        }()
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

//MARK: Mapview delegate
extension POIMapViewController: GMSMapViewDelegate {
    
    // Display and hide the popup view based on tapping the marker pin
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        didSelectMarker(marker: marker)
        
        return true
    }
    
    // Dismiss popup view if user clicks a point on the map that isn't a marker
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if let event = selectedEvent {
            dismissPopupView(newEvent: event, fullyDismissed: true, completionHandler: { _ in })
        }
    }
    
}
