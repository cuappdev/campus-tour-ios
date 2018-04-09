//
//  SearchHelpers.swift
//  CampusTour
//
//  Created by Ji Hwan Seung on 4/9/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit

class SearchHelper {
    
    //Takes in tag as input (it is the abbreviated form of the tags)
    static func getEventsFromTag(tag: String, events: [Event]) -> [Event] {
        var tagid: String = ""
        
        generalTagMapping.forEach { tagid = $0.value == tag ? $0.key : tagid }
        
        var taggedEvents = [Event]()
        
        for e in events {
            e.tags.forEach({ (etag) in
                if etag.id == tagid { taggedEvents.append(e) }
            })
        }
        return taggedEvents
    }
}
