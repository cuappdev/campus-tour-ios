import UIKit
import SnapKit
import CoreLocation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
    }
    
    func buildUI() {
        self.view.backgroundColor = UIColor.white
        
        let root = UIStackView()
        root.axis = .vertical
        
        let label = UILabel()
        label.text = "Hello, world!"
        root.addArrangedSubview(label)
        
        let mapViewButton = UIButton(type: .system)
        mapViewButton.setTitle("Go to map", for: .normal)
        mapViewButton.addTarget(self, action: #selector(goToMapVC), for: .touchUpInside)
        root.addArrangedSubview(mapViewButton)
        
        self.view.addSubview(root)
        root.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @IBAction func goToMapVC() {
        let pois = [
            POI(coords: CLLocationCoordinate2D(latitude: 42.444744, longitude: -76.482603))
        ]
        self.navigationController!.pushViewController(POIMapViewController(pois: pois), animated: true)
    }

}

