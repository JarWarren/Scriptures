//
//  TestamentCD.swift
//  BookOfMormon
//
//  Created by Jared Warren on 12/31/18.
//  Copyright © 2018 Warren. All rights reserved.
//

import Foundation
import CoreData

extension TestamentCD {
    
    convenience init(dictionary: [String : Any]) {
        self.init(context: CoreDataStack.managedObjectContext)
        guard let title = dictionary["title"] as? String else { return }
        self.title = title
        
    }
}
