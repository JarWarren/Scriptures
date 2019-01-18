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
    var primary: PrimaryGoalCD? {
        let fetchRequest: NSFetchRequest <PrimaryGoalCD> = PrimaryGoalCD.fetchRequest()
        return (try? CoreDataStack.managedObjectContext.fetch(fetchRequest).first ?? PrimaryGoalCD(context: CoreDataStack.managedObjectContext))
    }
    
    func createDeadlineGoal(name: String, endDate: Date, startingPoint: [Int]) {
        
        let newGoal = GoalCD(name: name, endDate: endDate, startingPoint: startingPoint)
        if primary?.goal == nil {
            primary?.goal = newGoal
        }
        try? CoreDataStack.managedObjectContext.save()
    }
    
    func createIncrementalGoal(name: String, startPosition: [Int], dailyChapters: Int) {
        
        let newGoal = GoalCD (name: name, dailyChapters: dailyChapters, startingPoint: startPosition)
        if primary?.goal == nil {
            primary?.goal = newGoal
        }
        try? CoreDataStack.managedObjectContext.save()
    }
    
    func setDifferentPrimaryGoal(goal: GoalCD) {
        self.primary?.goal = goal
        try? CoreDataStack.managedObjectContext.save()
    }
    
    func removePrimaryGoal() {
        
        self.primary?.goal = nil
        try? CoreDataStack.managedObjectContext.save()
    }
    
    func updatePrimaryGoalLocation(location: [Int]) {
        
        primary?.goal?.currentBook = Int64(location[1])
        primary?.goal?.currentChapter = Int64(location[2])
    }
    
    func delete(goal: GoalCD) {
        
        CoreDataStack.managedObjectContext.delete(goal)
        try? CoreDataStack.managedObjectContext.save()
    }
}
