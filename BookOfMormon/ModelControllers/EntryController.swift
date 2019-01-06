//
//  EntryController.swift
//  BookOfMormon
//
//  Created by Jared Warren on 1/5/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    static let shared = EntryController()
    private init () {}
    var allEntries: [EntryCD] {
       
        let fetchRequest: NSFetchRequest <EntryCD> = EntryCD.fetchRequest()
        return (try? CoreDataStack.managedObjectContext.fetch(fetchRequest)) ?? []
    }
    
    func createNewEntry(title: String, text: String) {
        
        _ = EntryCD(title: title, text: text)
        try? CoreDataStack.managedObjectContext.save()
    }
    
    func updateEntry(entry: EntryCD, title: String, text: String) {
        
        entry.entryTitle = title
        entry.entryText = text
        entry.entryDate = Date()
        try? CoreDataStack.managedObjectContext.save()
    }
    
    func deleteEntry(entry: EntryCD) {
        
        CoreDataStack.managedObjectContext.delete(entry)
        try? CoreDataStack.managedObjectContext.save()
    }
}
