//
//  GoalController.swift
//  BookOfMormon
//
//  Created by Jared Warren on 12/15/18.
//  Copyright © 2018 Warren. All rights reserved.
//

import Foundation
import CoreData

class GoalController {
    
    static let shared = GoalController()
    private init() {}
    var allGoals: [GoalCD]? {
        let fetchRequest: NSFetchRequest <GoalCD> = GoalCD.fetchRequest()
        return (try? CoreDataStack.managedObjectContext.fetch(fetchRequest)) ?? []
    }
    var primaryGoal: GoalCD?
    
    func createDeadlineGoal(name: String, endDate: Date, startingPoint: [Int]) {
        
        _ = GoalCD(name: name, endDate: endDate, startingPoint: startingPoint)
        try? CoreDataStack.managedObjectContext.save()
    }
    
    func createIncrementalGoal(name: String, startPosition: [Int], dailyChapters: Int) {
        
        _ = GoalCD (name: name, dailyChapters: dailyChapters, startingPoint: startPosition)
        try? CoreDataStack.managedObjectContext.save()
    }
    
    func updatePrimaryGoal(goal: GoalCD) {
        self.primaryGoal = goal
        try? CoreDataStack.managedObjectContext.save()
    }
    
    func delete(goal: GoalCD) {
        
        CoreDataStack.managedObjectContext.delete(goal)
        try? CoreDataStack.managedObjectContext.save()
    }
}
