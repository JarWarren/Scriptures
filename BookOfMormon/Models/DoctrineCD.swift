//
//  DoctrineCD.swift
//  BookOfMormon
//
//  Created by Jared Warren on 1/2/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import Foundation
import CoreData

extension DoctrineCD {
    
    convenience init(dictionary: [String : Any]) {
        self.init(context: CoreDataStack.managedObjectContext)
        guard let title = dictionary["title"] as? String else { return }
        self.title = title
        
    }
}
