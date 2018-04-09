//
//  PopupViewController.swift
//  CampusTour
//
//  Created by Ji Hwan Seung on 4/5/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit

protocol PopupFilterProtocol {
    func updateFilterBar(_ status: FilterBarCurrentStatus) -> ()
}

let allDates: [String] = {
    var d = DataManager.sharedInstance.times
    d.insert("Today", at: 0)
    return d
}()

class PopupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var data: PopupData = PopupData(filterBarStatus: FilterBarCurrentStatus(), filterMode: Filter.general, filterBarLocationCenterX: 0)
    let reuseID = "reuseID"
    let tableView = UITableView()
    var triangleView: TriangleView!
    private let triangleViewLength = CGFloat(10)
    private var currentCheckedCellIndex: IndexPath?
    var delegate: PopupFilterProtocol!
    
    override func viewDidLoad() {
        view.backgroundColor = .clear
        
        triangleView = TriangleView(frame: CGRect(x: 0, y: 0, width: triangleViewLength, height: triangleViewLength))
        triangleView.backgroundColor = .clear
        
        tableView.layer.cornerRadius = 5.0
        tableView.clipsToBounds = true
        
        view.addSubview(tableView)
        view.addSubview(triangleView)
        
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
    
    func remakeConstraints() {
        triangleView.snp.remakeConstraints { (make) in
            make.centerX.equalTo(data.filterBarLocationCenterX)
            make.top.equalToSuperview()
            make.height.equalTo(triangleViewLength)
            make.width.equalTo(triangleViewLength)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID) as! FilterTableViewCell
        cell.filterMode = self.data.filterMode
        switch data.filterMode {
        case .general:
            let info = FilterTableViewCell.Info(school: Tag.schoolFilters[indexPath.row], date: nil)
            if data.filterBarStatus.generalSelected == Tag.schoolFilters[indexPath.row].0 {
                cell.setupCell(info, true)
                currentCheckedCellIndex = indexPath
            } else {
                cell.setupCell(info)
            }
        case .date:
            let info = FilterTableViewCell.Info(school: nil, date: allDates[indexPath.row])
            if data.filterBarStatus.dateSelected == allDates[indexPath.row] {
                cell.setupCell(info, true)
                currentCheckedCellIndex = indexPath
            } else {
                cell.setupCell(info)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch data.filterMode {
        case .general:
            data.filterBarStatus.generalSelected = Tag.schoolFilters[indexPath.row].0
        case .date:
            data.filterBarStatus.dateSelected = allDates[indexPath.row]
        }
        tableView.reloadRows(at: [indexPath, currentCheckedCellIndex!], with: UITableViewRowAnimation.none)
        currentCheckedCellIndex = indexPath
        
        delegate.updateFilterBar(data.filterBarStatus)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch data.filterMode {
        case .general:
            return Tag.schoolFilters.count
        case .date:
            return allDates.count
        }
    }
    
    //Maintain highlighted index
    func resetVariables(status: FilterBarCurrentStatus, filterMode: Filter) {
        var indexPath: IndexPath!
        switch filterMode {
        case .general:
            let i = Tag.schoolFilters.index(where: { (a,_) -> Bool in
                a == status.generalSelected
            })
            indexPath = IndexPath(row: i!, section: 0)
        case .date:
            indexPath = IndexPath(row: allDates.index(of: status.dateSelected)!, section: 0)
        }
        currentCheckedCellIndex = indexPath
    }
}
