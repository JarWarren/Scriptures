//
//  BookmarkCD.swift
//  BookOfMormon
//
//  Created by Jared Warren on 1/3/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import Foundation

extension BookmarkCD {
    
    convenience init(testament: Int, book: Int, chapter: Int) {
        
        self.init(context: CoreDataStack.managedObjectContext)
        self.testament = Int64(testament)
        self.book = Int64(book)
        self.chapter = Int64(chapter)
    }
}
