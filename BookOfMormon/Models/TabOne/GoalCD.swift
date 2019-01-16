//
//  GoalCD.swift
//  BookOfMormon
//
//  Created by Jared Warren on 1/8/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import Foundation

extension GoalCD {
    
    convenience init(name: String, endDate: Date, startingPoint: [Int]) {
        self.init(context: CoreDataStack.managedObjectContext)
        self.name = name
        self.startDate = Date()
        self.desiredEndDate = endDate
        self.testament = Int64(startingPoint[0])
        self.currentBook = Int64(startingPoint[1])
        self.currentChapter = Int64(startingPoint[2])
        self.currentVerse = 0
    }
    
    convenience init(name: String, dailyChapters: Int, startingPoint: [Int]) {
        self.init(context: CoreDataStack.managedObjectContext)
        self.name = name
        self.startDate = Date()
        self.dailyChapters = Int64(dailyChapters)
        self.testament = Int64(startingPoint[0])
        self.currentBook = Int64(startingPoint[1])
        self.currentChapter = Int64(startingPoint[2])
        self.currentVerse = 0
        self.isComplete = false
    }
}
