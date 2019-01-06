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
    var memorizingVerses = [VerseCD]()
    
    func memorize(verse: VerseCD) {
        
        memorizingVerses.append(verse)
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
