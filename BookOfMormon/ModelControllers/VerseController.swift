//
//  VerseController.swift

//  BookOfMormon
//
//  Created by Jared Warren on 1/5/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import Foundation
import CoreData

class VerseController {
    
    static let shared = VerseController()
    private init() {}
    var memorizingVerses: [MemorizedVersesCD]? {
        
        let fetchRequest: NSFetchRequest <MemorizedVersesCD> = MemorizedVersesCD.fetchRequest()
        let memorized = try? CoreDataStack.managedObjectContext.fetch(fetchRequest)
        return memorized ?? []
    }
    
    func memorize(verses: [VerseCD]) {
        
        let newMemorized = MemorizedVersesCD(memorized: false)
        for verse in verses {
            newMemorized.addToVerses(verse)
        }
        try? CoreDataStack.managedObjectContext.save()
    }
    
    func toggleMemorized(verses: MemorizedVersesCD) {
        
        verses.memorized.toggle()
        try? CoreDataStack.managedObjectContext.save()
    }
    
    func deleteMemorizedVerses(verses: MemorizedVersesCD) {
        
        CoreDataStack.managedObjectContext.delete(verses)
        try? CoreDataStack.managedObjectContext.save()
    }
    
    static func addNoteTo(verse: VerseCD, title: String, body: String) {
        
        verse.noteTitle = title
        verse.noteText = body
        verse.noteDate = Date()
        try? CoreDataStack.managedObjectContext.save()
    }
    
    static func deleteNoteFrom(verse: VerseCD) {
        
        verse.noteText = nil
        verse.noteTitle = nil
        verse.noteDate = nil
        try? CoreDataStack.managedObjectContext.save()
    }
}
