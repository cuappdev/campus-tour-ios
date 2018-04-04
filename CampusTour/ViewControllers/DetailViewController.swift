//
//  DetailViewController.swift
//  CampusTour
//
//  Created by Ji Hwan Seung on 3/25/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit
import GoogleMaps
import AlamofireImage

class DetailViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let topView = UIView()
    let scheduleStackView = UIStackView()
    let aboutStackView = UIStackView()
    let mapView = UIView()
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeViews()
    }
    
    func initializeViews() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints{ (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        //Scrollview keeps disappearing under tabbar
        let contentView = UIView.insetWrapper(view: UIView(), insets: UIEdgeInsetsMake(0, 0, self.additionalSafeAreaInsets.bottom, 0))
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints{ (make) in
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
       
        contentView.addSubview(topView)
        
        let scheduleView = UIView.insetWrapper(view: scheduleStackView, insets: UIEdgeInsetsMake(0, 20, 0, 0))
        contentView.addSubview(scheduleView)
        let aboutView = UIView.insetWrapper(view: aboutStackView, insets: UIEdgeInsetsMake(0, 20, 0, 0))
        let lineView: UIView = {
            let line = UIView()
            line.backgroundColor = Colors.shadow
            return line
        }()
        contentView.addSubview(lineView)
        contentView.addSubview(aboutView)
        contentView.addSubview(mapView)
        
        topView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.38)
        }
        scheduleView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(topView.snp.height).multipliedBy(0.35)
        }
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(scheduleView.snp.bottom)
            make.bottom.equalTo(aboutView.snp.top)
            make.height.equalTo(1)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        aboutView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        mapView.snp.makeConstraints { (make) in
            make.top.equalTo(aboutStackView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(topView.snp.height).multipliedBy(0.52)
            make.bottom.equalToSuperview()
        }
        
        createTopView()
        createScheduleView()
        createAboutStackView()
        createMapView()
    }
    
    private func createTopView() {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        //TODO: replace with actual image URL from data
        imageView.af_setImage(withURL: URL(string: "https://picsum.photos/150/150/?random")!)
        
        let titleLabel = UILabel()
        titleLabel.text = event.name
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        
        let tagsView = UIView()
        var tagViewList = [UIView]()
        
        for (index, tag) in event.tags.enumerated() {
            let tagLabel = UILabel()
            tagLabel.text = tag
            tagLabel.textColor = .white
            tagLabel.backgroundColor = UIColor.clear
            tagLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
            tagLabel.sizeToFit()
            let insets = UIEdgeInsetsMake(7, 14, 7, 14)
            let tagView = UIView.insetWrapper(view: tagLabel, insets: insets)
            tagView.layer.borderColor = UIColor.white.cgColor
            tagView.layer.borderWidth = 1.0
            tagView.layer.cornerRadius = 4.0
            tagViewList.append(tagView)
            tagsView.addSubview(tagView)
            if index == 0 {
                tagView.snp.makeConstraints({ (make) in
                    make.leading.equalToSuperview()
                })
            } else {
                tagView.snp.makeConstraints({ (make) in
                    make.leading.equalTo(tagViewList[index-1].snp.trailing).offset(5)
                })
            }
            tagView.snp.makeConstraints({ (make) in
                make.bottom.equalToSuperview()
            })
        }
        
        imageView.addSubview(tagsView)
        imageView.addSubview(titleLabel)
        tagsView.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-13)
            make.height.equalTo(25)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(tagsView.snp.top).offset(-10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview()
        }
        
        topView.addSubview(imageView)
        imageView.snp.makeConstraints{ $0.edges.equalToSuperview() }
    }
    
    private func createScheduleView() {
        let mainTitleLabel = UILabel()
        let dateLocationLabel = UILabel()
        
        mainTitleLabel.text = DateHelper.getFormattedDate(event.startTime)
        mainTitleLabel.textColor = Colors.brand
        mainTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        let time = DateHelper.getFormattedTime(startTime: event.startTime, endTime: event.endTime)
        let location = event.locationName
        dateLocationLabel.text = time + "·" + location
        dateLocationLabel.textColor = Colors.tertiary
        dateLocationLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        scheduleStackView.addArrangedSubview(mainTitleLabel)
        scheduleStackView.addArrangedSubview(dateLocationLabel)
        scheduleStackView.distribution = .equalCentering
        scheduleStackView.spacing = 3.0
        scheduleStackView.axis = .vertical
        scheduleStackView.isLayoutMarginsRelativeArrangement = true
    }
    
    private func createAboutStackView() {
        let description = event?.description
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "About the Event"
            label.textColor = Colors.primary
            label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            return label
        }()
        
        let descriptionView: UILabel = {
            let desc = UILabel()
            desc.text = description
            desc.textColor = Colors.secondary
            desc.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            desc.numberOfLines = 0
            return desc
        }()
        
        //TODO: fix button (maybe use external framework)
        let showMoreButton: UIButton = {
            let button = UIButton()
            button.setTitle("Show More", for: .normal)
            button.setTitleColor(Colors.brand, for: .normal)
            button.addTarget(self, action: #selector(showMore), for: .touchUpInside)
            button.tag = Int(descriptionView.intrinsicContentSize.height)
            return button
        }()
        
        aboutStackView.addArrangedSubview(titleLabel)
        aboutStackView.addArrangedSubview(descriptionView)
        aboutStackView.spacing = 3.0
        aboutStackView.alignment = .leading
        aboutStackView.axis = .vertical
        aboutStackView.distribution = .equalCentering
    }
    
    private func createMapView() {
        let map = GMSMapView.map(withFrame: CGRect.zero, camera: GMSCameraPosition.camera(withLatitude: 0.0, longitude: 0.0, zoom: 12.0))
        AppDelegate.shared!.locationProvider.addLocationListener(repeats: false) { [weak self] location in
            map.moveCamera(GMSCameraUpdate.setTarget(location.coordinate))
        }
        mapView.addSubview(map)
        map.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    @objc private func showMore(_ sender: UIButton) {
        aboutStackView.snp.remakeConstraints{ $0.height.equalTo(sender.tag) }
        sender.removeFromSuperview()
    }
}
