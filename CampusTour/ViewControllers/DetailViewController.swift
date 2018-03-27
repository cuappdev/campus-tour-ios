//
//  DetailViewController.swift
//  CampusTour
//
//  Created by Ji Hwan Seung on 3/25/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit
import GoogleMaps

class DetailViewController: UIViewController {
    
    var mainStackView: UIStackView!
    var topView: UIView!
    var scheduleStackView: UIStackView!
    var aboutStackView: UIStackView!
    var mapView: UIView!
    
    var data: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialize Views
        mainStackView = UIStackView()
        topView = UIView()
        scheduleStackView = UIStackView()
        aboutStackView = UIStackView()
        mapView = {
            let view = UIView()
            let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: GMSCameraPosition.camera(withLatitude: 0.0, longitude: 0.0, zoom: 12.0))
            AppDelegate.shared!.locationProvider.addLocationListener(repeats: false) { [weak self] location in
                mapView.moveCamera(GMSCameraUpdate.setTarget(location.coordinate))
            }
            view.addSubview(mapView)
            mapView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            return view
        }()
        
        view.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        setupStackViews()
    }
    
    func setupStackViews() {
        guard let unwrappedData = data else { return }
        mainStackView.addArrangedSubview(topView)

        if let event = unwrappedData as? Event {
            createScheduleStackView(event: event)
            mainStackView.addArrangedSubview(scheduleStackView)
        }
        createAboutStackView(data: unwrappedData)
        mainStackView.addArrangedSubview(aboutStackView)
        mainStackView.addArrangedSubview(mapView)
        
        mainStackView.alignment = .top
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillProportionally
    }
    
    private func createTopView(data: Any) {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        //TODO: add image to imageView
        imageView.backgroundColor = .lightGray
        
        var description = ""
        let titleLabel = UILabel()
        if let event = data as? Event {
            description = event.name
        }
        titleLabel.text = description
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        
        //Fix this font later
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        
        imageView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview()
        }
        topView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
        }
    }
    
    private func createScheduleStackView(event: Event) {
        let mainTitleLabel = UILabel()
        let dateLocationLabel = UILabel()
        
        mainTitleLabel.text = "Happening tonight"
        mainTitleLabel.textColor = Colors.brand
        mainTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        dateLocationLabel.text = "date + location"
        dateLocationLabel.textColor = Colors.tertiary
        dateLocationLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        scheduleStackView.addArrangedSubview(mainTitleLabel)
        scheduleStackView.addArrangedSubview(dateLocationLabel)
        scheduleStackView.distribution = .equalSpacing
        scheduleStackView.spacing = 3.0
        scheduleStackView.alignment = .leading
        scheduleStackView.axis = .vertical
        scheduleStackView.isLayoutMarginsRelativeArrangement = true
    }
    
    private func createAboutStackView(data: Any) {
        var description = ""
        if let event = data as? Event {
            description = event.description
        }
        //Not sure what to put for buildings for now
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "About the Event"
            label.textColor = Colors.brand
            label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            return label
        }()
        
        let descriptionLabel: UILabel = {
            let label = UILabel()
            label.text = description
            label.textColor = Colors.secondary
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            return label
        }()
        
        aboutStackView.addArrangedSubview(titleLabel)
        aboutStackView.addArrangedSubview(descriptionLabel)
        aboutStackView.spacing = 3.0
        aboutStackView.alignment = .leading
        aboutStackView.axis = .vertical
        aboutStackView.distribution = .equalSpacing
    }
}