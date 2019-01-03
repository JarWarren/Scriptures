//
//  SectionCD+CoreDataClass.swift
//  BookOfMormon
//
//  Created by Jared Warren on 1/2/19.
//  Copyright © 2019 Warren. All rights reserved.
//
//

import Foundation
import CoreData

@objc(SectionCD)
public class SectionCD: NSManagedObject {
    
    var versesTemp: [[String : Any]]?
}

extension SectionCD {
    
    convenience init(dictionary: [String : Any], doctrine: DoctrineCD) {
        self.init(context: CoreDataStack.managedObjectContext)
        
        guard let section = dictionary["section"] as? Int,
            let reference = dictionary["reference"] as? String,
            let verses = dictionary["verses"] as? [[String : Any]]
            else { return }
        
        self.section = Int64(section)
        self.reference = reference
        self.doctrine = doctrine
        self.versesTemp = verses
    }
}
