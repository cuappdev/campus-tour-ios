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
    
    var descriptionView: UILabel!
    var titleLabel: UILabel!
    var bookmarkButton: UIButton!
    var event: Event!
    
    private let textInset = CGFloat(20)
    private let textPadding = CGFloat(12)
    private let textSubPadding = CGFloat(8)
    
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
        scrollView.alwaysBounceVertical = true
        
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
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        let imageUrl = (event.location.imageUrl != "") ? event.location.imageUrl : defaultLocationImageUrl
        imageView.af_setImage(withURL: URL(string: imageUrl)!)
        
        let imageOverlay = UIView()
        imageOverlay.backgroundColor = .black
        imageOverlay.alpha = 0.3
        
        let titleLabel = UILabel()
        titleLabel.text = event.name
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        titleLabel.font = Fonts.headerFont
        titleLabel.numberOfLines = 0

        let tagView = TagView(
            tags: event.tags.flatMap {$0.generalTagMap(id: $0.id)},
            style: TagView.Style(
                tagInsets: UIEdgeInsetsMake(7, 14, 7, 14),
                color: .white))
        
        imageView.addSubview(imageOverlay)
        imageView.addSubview(titleLabel)
        imageView.addSubview(tagView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(tagView.snp.top).offset(-10)
            make.leading.equalToSuperview().offset(textInset)
            make.trailing.equalToSuperview()
        }
        
        tagView.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-15)
            make.height.equalTo(25)
        }
        
        topView.addSubview(imageView)
        
        imageView.snp.makeConstraints{ $0.edges.equalToSuperview() }
        imageOverlay.snp.makeConstraints{ $0.edges.equalToSuperview() }
    }
    
    @IBAction func toggleBookmark() {
        BookmarkHelper.updateBookmark(id: event.id)
        
        bookmarkButton.setImage(BookmarkHelper.isEventBookmarked(event.id) ? #imageLiteral(resourceName: "FilledBookmarkIcon") : #imageLiteral(resourceName: "EmptyBookmarkIcon"), for: .normal)
        print("event bookmarked: ", BookmarkHelper.isEventBookmarked(event.id))
    }
    
    private func createScheduleView() {
        let mainTitleLabel = UILabel()
        let dateLocationLabel = UILabel()
        
        mainTitleLabel.text = "Happening \(DateHelper.getFormattedDate(event.startTime))"
        mainTitleLabel.textColor = Colors.brand
        mainTitleLabel.font = Fonts.titleFont
        
        let time = DateHelper.getStartEndTime(startTime: event.startTime, endTime: event.endTime)
        let loc = event.location.name
        dateLocationLabel.text = "\(time) · \(loc)"
        dateLocationLabel.textColor = Colors.tertiary
        dateLocationLabel.font = Fonts.bodyFont
        
        bookmarkButton = UIButton()
        bookmarkButton.setImage(BookmarkHelper.isEventBookmarked(event.id) ? #imageLiteral(resourceName: "FilledBookmarkIcon") : #imageLiteral(resourceName: "EmptyBookmarkIcon"), for: .normal)
        bookmarkButton.addTarget(self, action: #selector(toggleBookmark), for: .touchUpInside)
        
        scheduleView.addSubview(mainTitleLabel)
        scheduleView.addSubview(dateLocationLabel)
        scheduleView.addSubview(bookmarkButton)
        
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
        
        bookmarkButton.snp.makeConstraints { (make) in
            make.top.equalTo(mainTitleLabel.snp.top)
            make.trailing.equalToSuperview().offset(-textInset)
            make.width.equalTo(18)
            make.height.equalTo(bookmarkButton.snp.width).multipliedBy(28.9 / 17.4)
        }
        
    }
    
    private func createAboutView() {
        let description = event?.description
        titleLabel = {
            let label = UILabel()
            label.text = "About the Event"
            label.textColor = Colors.primary
            label.font = Fonts.titleFont
            return label
        }()
        
        descriptionView = {
            let desc = UILabel()
            desc.text = description
            desc.textColor = Colors.secondary
            desc.font = Fonts.bodyFont
            desc.numberOfLines = 0
            return desc
        }()
        
        let descHeight = description!.height(withConstrainedWidth: view.frame.width, font: Fonts.bodyFont)
        let minDescHeight = min(descHeight, 55)
        
        //TODO: fix button (maybe use external framework)
        let showMoreButton: UIButton = {
            let button = UIButton()
            button.titleLabel?.font = Fonts.actionFont
            button.setTitle("Show More", for: .normal)
            button.setTitleColor(Colors.brand, for: .normal)
            button.addTarget(self, action: #selector(showMore), for: .touchUpInside)
            button.tag = Int(description!.height(withConstrainedWidth: view.frame.width, font: Fonts.bodyFont))
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
            make.height.equalTo(minDescHeight)
        }
        
        if minDescHeight != descHeight {
            aboutView.addSubview(showMoreButton)
            showMoreButton.snp.makeConstraints { (make) in
                make.trailing.equalToSuperview().offset(-textInset)
                make.top.equalTo(descriptionView.snp.bottom).offset(textSubPadding)
                make.bottom.equalToSuperview().offset(-textInset)
                make.width.equalTo(100)
                make.height.equalTo(16)
            }
        }
    }
    
    private func createMapView() {
        let coords = CLLocationCoordinate2DMake(CLLocationDegrees(event.location.lat), CLLocationDegrees(event.location.lng))
        let map = GMSMapView.map(withFrame: CGRect.zero, camera: GMSCameraPosition.camera(withTarget: coords, zoom: 15))
        
        let marker = GMSMarker(position: coords)
        marker.userData = event
        marker.iconView = PlaceMarker()
        marker.map = map
        
        mapView.addSubview(map)
        map.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func createDirectionView() {
        let address = event.location.address
        let lineView = UIView()
        lineView.backgroundColor = Colors.shadow
        let lineView2 = UIView()
        lineView2.backgroundColor = Colors.shadow
        
        let addressLabel = UILabel()
        addressLabel.text = address
        addressLabel.font = Fonts.bodyFont
        addressLabel.textColor = Colors.secondary
        
        let directionsButton = UIButton()
        directionsButton.setTitle("Directions", for: .normal)
        directionsButton.setTitleColor(Colors.systemBlue, for: .normal)
        directionsButton.titleLabel?.font = Fonts.bodyFont
        directionsButton.contentHorizontalAlignment = .trailing
        directionsButton.addTarget(self, action: #selector(self.directionsButtonPressed(_:)), for: .touchUpInside)
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
    
    @objc func directionsButtonPressed(_ sender: UIButton) {
        showDirectionsPopupView(event: event)
    }
    
    @objc private func showMore(_ sender: UIButton) {
        sender.removeFromSuperview()
        descriptionView.snp.remakeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(textSubPadding)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(titleLabel.snp.trailing)
            make.bottom.equalToSuperview().offset(-textInset)
        }
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
}

