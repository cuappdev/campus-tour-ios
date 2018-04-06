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
    let scheduleView = UIView()
    let aboutView = UIView()
    let mapView = UIView()
    let directionsView = UIView()
    var event: Event!
    
    private let textInset = CGFloat(20)
    private let textPadding = CGFloat(12)
    private let textSubPadding = CGFloat(8)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("vc disappearing")
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
        scrollView.alwaysBounceVertical = true
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
        contentView.addSubview(scheduleView)
        let lineView: UIView = {
            let line = UIView()
            line.backgroundColor = Colors.shadow
            return line
        }()
        contentView.addSubview(lineView)
        contentView.addSubview(aboutView)
        contentView.addSubview(mapView)
        contentView.addSubview(directionsView)
        
        topView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(view.safeAreaLayoutGuide.snp.height).multipliedBy(0.38)
        }
        scheduleView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(scheduleView.snp.bottom)
            make.bottom.equalTo(aboutView.snp.top)
            make.height.equalTo(1)
            make.leading.equalToSuperview().offset(textInset)
            make.trailing.equalToSuperview().offset(-textInset)
        }
        aboutView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        mapView.snp.makeConstraints { (make) in
            make.top.equalTo(aboutView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(topView.snp.height).multipliedBy(0.52)
        }
        directionsView.snp.makeConstraints { (make) in
            make.top.equalTo(mapView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(40)
        }
        
        createTopView()
        createScheduleView()
        createAboutView()
        createMapView()
        createDirectionView()
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
            tagLabel.text = tag.label
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
            make.bottom.equalToSuperview().offset(-15)
            make.height.equalTo(25)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(tagsView.snp.top).offset(-10)
            make.leading.equalToSuperview().offset(textInset)
            make.trailing.equalToSuperview()
        }
        
        topView.addSubview(imageView)
        imageView.snp.makeConstraints{ $0.edges.equalToSuperview() }
    }
    
    private func createScheduleView() {
        let mainTitleLabel = UILabel()
        let dateLocationLabel = UILabel()
        //TODO Create bookmark
        let bookmarkButton = UIButton()
        
        mainTitleLabel.text = "Happening \(DateHelper.getFormattedDate(event.startTime))"
        mainTitleLabel.textColor = Colors.brand
        mainTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        let time = DateHelper.getFormattedTime(startTime: event.startTime, endTime: event.endTime)
        let loc = event.location.name
        dateLocationLabel.text = "\(time) · \(loc)"
        dateLocationLabel.textColor = Colors.tertiary
        dateLocationLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        scheduleView.addSubview(mainTitleLabel)
        scheduleView.addSubview(dateLocationLabel)
        
        mainTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(textInset)
            make.trailing.equalToSuperview().offset(-textInset)
            make.leading.equalToSuperview().offset(textInset)
            make.height.equalTo(19)
        }
        dateLocationLabel.snp.makeConstraints { (make) in
            make.top.equalTo(mainTitleLabel.snp.bottom).offset(textSubPadding)
            make.trailing.equalTo(mainTitleLabel)
            make.leading.equalTo(mainTitleLabel)
            make.height.equalTo(18)
            make.bottom.equalToSuperview().offset(-textInset)
        }
    }
    
    private func createAboutView() {
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
        
        aboutView.addSubview(titleLabel)
        aboutView.addSubview(descriptionView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(textInset)
            make.leading.equalToSuperview().offset(textInset)
            make.trailing.equalToSuperview().offset(-textInset)
            make.height.equalTo(19)
        }
        descriptionView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(textSubPadding)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(titleLabel.snp.trailing)
            make.bottom.equalToSuperview().offset(-textInset)
        }
    }
    
    private func createMapView() {
        let map = GMSMapView.map(withFrame: CGRect.zero, camera: GMSCameraPosition.camera(withLatitude: 0.0, longitude: 0.0, zoom: 12.0))
        AppDelegate.shared!.locationProvider.addLocationListener(repeats: false) { [weak self] location in
            map.moveCamera(GMSCameraUpdate.setTarget(location.coordinate))
        }
        mapView.addSubview(map)
        map.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func createDirectionView() {
        //TODO: Fix location to be address using DataManager
        let address = "243 Upson Hall, Ithaca NY 14853"
        let lineView = UIView()
        lineView.backgroundColor = Colors.shadow
        let lineView2 = UIView()
        lineView2.backgroundColor = Colors.shadow
        
        let addressLabel = UILabel()
        addressLabel.text = address
        addressLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        addressLabel.textColor = Colors.secondary
        
        let directionsButton = UIButton()
        directionsButton.setTitle("Directions", for: .normal)
        directionsButton.setTitleColor(Colors.systemBlue, for: .normal)
        directionsButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        directionsButton.contentHorizontalAlignment = .trailing
        directionsButton.sizeToFit()
        
        directionsView.addSubview(lineView)
        directionsView.addSubview(lineView2)
        directionsView.addSubview(addressLabel)
        directionsView.addSubview(directionsButton)
        lineView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalToSuperview()
        }
        addressLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(textInset)
            make.trailing.equalTo(directionsButton.snp.leading).offset(textInset)
            make.top.equalTo(lineView.snp.bottom).offset(textPadding)
            make.bottom.equalToSuperview().offset(-textPadding)
        }
        directionsButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-textInset)
            make.top.equalTo(addressLabel.snp.top)
            make.bottom.equalTo(addressLabel.snp.bottom)
        }
        lineView2.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(directionsView.snp.bottom).offset(-1)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc private func showMore(_ sender: UIButton) {
        aboutView.snp.remakeConstraints{ $0.height.equalTo(sender.tag) }
        sender.removeFromSuperview()
    }
}
