//
//  PopupViewController.swift
//  CampusTour
//
//  Created by Ji Hwan Seung on 4/5/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit

enum FilterMode {
    case general, date
}

fileprivate let generalFilters: [(String, String)] = [
    ("A&S","Arts and Sciences"),
    ("AAP","Arts, Architecture, and Planning"),
    ("CALS", "Agriculture and Life Science"),
    ("ENG", "Engineering"),
    ("HE", "Human Ecology"),
    ("ILR", "Industrial and Labor Relations"),
    ("JCB Dyson", "SC Johnson School of Business"),
    ("JCB Hotel", "SC Johnson School of Business"),
]

fileprivate let dateFilters: [Dates] = [
    Dates.a13,
    Dates.a15,
    Dates.a16,
    Dates.a18,
    Dates.a19,
    Dates.a20,
    Dates.a22,
    Dates.a23,
]

class PopupViewController: UITableViewController {
    
    var isClicked = ""
    var filterMode: FilterMode!
    let reuseID = "reuseID"
    
    override func viewDidLoad() {
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: reuseID)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID) as! FilterTableViewCell
        cell.filterMode = self.filterMode
        
        switch filterMode {
        case .general:
            if isClicked == generalFilters[indexPath.row].0 {
                cell.setupCell(generalFilters[indexPath.row], true)
            } else {
                cell.setupCell(generalFilters[indexPath.row])
            }
        case .date:
            if isClicked == generalFilters[indexPath.row].0 {
                cell.setupCell(dateFilters[indexPath.row], true)
            } else {
                cell.setupCell(generalFilters[indexPath.row])
            }
        default: return UITableViewCell()
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
