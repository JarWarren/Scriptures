//
//  MemorizedVerse.swift
//  BookOfMormon
//
//  Created by Jared Warren on 1/7/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import Foundation

extension MemorizedVersesCD {
    
    convenience init(verses: [VerseCD]) {
        self.init(context: CoreDataStack.managedObjectContext)
        self.memorized = false
        for verse in verses {
//            self.insertIntoVerses(verse, at: self.verses?.count ?? 0)
            self.addToVerses(verse)
        }
    }
}
