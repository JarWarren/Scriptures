//
//  EntryCD.swift
//  BookOfMormon
//
//  Created by Jared Warren on 1/5/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import Foundation

extension EntryCD {
    
    convenience init(title: String, text: String) {
        self.init(context: CoreDataStack.managedObjectContext)
        self.entryTitle = title
        self.entryText = text
        self.entryDate = Date()
    }
}
