//
//  PopupViewController.swift
//  CampusTour
//
//  Created by Ji Hwan Seung on 4/5/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var data: PopupData = PopupData(generalSelected: "General", dateSelected: nil, filterMode: Filter.general, filterBarLocationCenterX: 0)
    let reuseID = "reuseID"
    let tableView = UITableView()
    var triangleView: TriangleView!
    private let triangleViewLength = CGFloat(10)
    
    override func viewDidLoad() {
        view.backgroundColor = .clear
        
        triangleView = TriangleView(frame: CGRect(x: 0, y: 0, width: triangleViewLength, height: triangleViewLength))
        triangleView.backgroundColor = .clear
        
        tableView.layer.cornerRadius = 5.0
        tableView.clipsToBounds = true
        
        view.addSubview(tableView)
        view.addSubview(triangleView)
        
        triangleView.snp.makeConstraints { (make) in
            make.centerX.equalTo(data.filterBarLocationCenterX)
            make.top.equalToSuperview()
            make.height.equalTo(triangleViewLength)
            make.width.equalTo(triangleViewLength)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(triangleView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: reuseID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.bounces = false
    }
    
    override func updateViewConstraints() {
        triangleView.snp.updateConstraints { (make) in
            make.centerX.equalTo(data.filterBarLocationCenterX)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(triangleViewLength)
            make.width.equalTo(triangleViewLength)
        }
        super.updateViewConstraints()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID) as! FilterTableViewCell
        cell.filterMode = self.data.filterMode
        switch data.filterMode {
        case .general:
            let info = FilterTableViewCell.Info(school: Tag.schoolFilters[indexPath.row], date: nil)
            if data.generalSelected == Tag.schoolFilters[indexPath.row].0 {
                cell.setupCell(info, true)
            } else {
                cell.setupCell(info)
            }
        case .date:
            let info = FilterTableViewCell.Info(school: nil, date: dateFilters[indexPath.row])
            if data.dateSelected == dateFilters[indexPath.row] {
                cell.setupCell(info, true)
            } else {
                cell.setupCell(info)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch data.filterMode {
        case .general:
            return Tag.schoolFilters.count
        case .date:
            return dateFilters.count
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch registered in popup")
    }
}
