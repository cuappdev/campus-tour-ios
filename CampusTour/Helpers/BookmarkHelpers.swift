//
//  BookmarkHelpers.swift
//  CampusTour
//
//  Created by Ji Hwan Seung on 4/11/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit

class BookmarkHelper {
    static func isEventBookmarked(_ id: String) -> Bool {
        let bookmarks = UserDefaults.standard.stringArray(forKey: "bookmarks") ?? []
        return bookmarks.contains(id)
    }
    
    static func updateBookmark(id: String) {
        var bookmarks = UserDefaults.standard.stringArray(forKey: "bookmarks") ?? []
        if !bookmarks.contains(id) {
            bookmarks.append(id)
        } else {
            bookmarks.remove(at: bookmarks.index(of: id)!)
        }
        UserDefaults.standard.set(bookmarks, forKey: "bookmarks");
    }
}
