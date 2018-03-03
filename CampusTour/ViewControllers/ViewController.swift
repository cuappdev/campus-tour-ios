import UIKit
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUI()
    }
    
    func buildUI() {
        self.view.backgroundColor = UIColor.white
        
        let label = UILabel()
        label.text = "Hello, world!"
        self.view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

}

