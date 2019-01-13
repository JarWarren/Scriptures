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
    
    var bookmark: BookmarkCD? = {
        let fetchRequest: NSFetchRequest <BookmarkCD> = BookmarkCD.fetchRequest()
        guard let bookmarks = try? CoreDataStack.managedObjectContext.fetch(fetchRequest) else { return nil }
        print(bookmarks.count)
        return bookmarks.last
    }()
    
    func bookmarkAt(location: [Int]) {
        
        let testament = location[0]
        let book = location[1]
        let chapter = location[2]
        
        guard let bookmark = bookmark else {
            self.bookmark = BookmarkCD(testament: testament, book: book, chapter: chapter)
            try? CoreDataStack.managedObjectContext.save()
            return
        }
        
        switch bookmark.testament == location[0] &&
        bookmark.book == location[1] &&
        bookmark.chapter == location[2] {
        case true:
            CoreDataStack.managedObjectContext.delete(bookmark)
            self.bookmark = nil
        case false:
            bookmark.testament = Int64(testament)
            bookmark.book = Int64(book)
            bookmark.chapter = Int64(chapter)
        }
        do {
            try CoreDataStack.managedObjectContext.save()
        } catch {
            print("BOOKMARK NOT SAVED")
        }
    }
}
