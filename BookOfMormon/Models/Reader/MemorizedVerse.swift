//
//  MemorizedVerse.swift
//  BookOfMormon
//
//  Created by Jared Warren on 1/7/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import Foundation

extension MemorizedVersesCD {
    
    convenience init(memorized: Bool = false) {
        self.init(context: CoreDataStack.managedObjectContext)
        self.memorized = memorized
    }
}
