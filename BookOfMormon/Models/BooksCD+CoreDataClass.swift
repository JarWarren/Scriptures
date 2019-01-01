//
//  BooksCD+CoreDataClass.swift
//  BookOfMormon
//
//  Created by Jared Warren on 12/31/18.
//  Copyright © 2018 Warren. All rights reserved.
//
//

import Foundation
import CoreData

@objc(BooksCD)
public class BooksCD: NSManagedObject {

    var chaptersTemp: [[String : Any]]?
    
}

extension BooksCD {
    
    convenience init(dictionary: [String : Any], testament: TestamentCD) {
        self.init(context: CoreDataStack.managedObjectContext)
        guard let title = dictionary["full_title"] as? String,
            let book = dictionary["book"] as? String,
            let chapters = dictionary["chapters"] as? [[String : Any]]
            else { return }
        
        self.title = title
        self.book = book
        self.chaptersTemp = chapters
        
        
    }
}
