//
//  ChapterCD+CoreDataClass.swift
//  BookOfMormon
//
//  Created by Jared Warren on 12/31/18.
//  Copyright © 2018 Warren. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ChapterCD)
public class ChapterCD: NSManagedObject {

    var versesTemp: [[String : Any]]?
}

extension ChapterCD {
    
    convenience init(dictionary: [String : Any], book: BooksCD) {
        self.init(context: CoreDataStack.managedObjectContext)
        
        guard let chapter = dictionary["chapter"] as? Int,
            let reference = dictionary["reference"] as? String,
            let verses = dictionary["verses"] as? [[String : Any]]
            else { return }
    
        self.chapter = Int64(chapter)
        self.reference = reference
        self.book = book
        self.versesTemp = verses
    }
}
