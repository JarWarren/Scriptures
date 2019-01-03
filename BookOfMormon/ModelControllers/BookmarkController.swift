//
//  BookmarkController.swift
//  BookOfMormon
//
//  Created by Jared Warren on 1/3/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import Foundation
import CoreData

class BookmarkController {
    
    static let shared = BookmarkController()
    private init () {}
    var bookmark: BookmarkCD?
    
    func bookmarkAt(location: [Int]) {
        
        self.bookmark?.testament = Int64(location[0])
        self.bookmark?.book = Int64(location[1])
        self.bookmark?.chapter = Int64(location[2])
        self.bookmark?.verse = Int64(location[3])
    }
}
