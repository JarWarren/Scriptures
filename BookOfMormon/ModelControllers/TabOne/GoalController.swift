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
        setDifferentPrimaryGoal(goal: newGoal)
    }
    
    func createIncrementalGoal(name: String, startPosition: [Int], dailyChapters: Int) {
        
        let newGoal = GoalCD (name: name, dailyChapters: dailyChapters, startingPoint: startPosition)
        setDifferentPrimaryGoal(goal: newGoal)
    }
    
    func setDifferentPrimaryGoal(goal: GoalCD) {
        self.primary?.goal?.isPrimary = false
        self.primary?.goal = goal
        self.primary?.goal?.isPrimary = true
        try? CoreDataStack.managedObjectContext.save()
    }
    
    func removePrimaryGoal() {
        if let goal = primary?.goal {
            invalidateGoal(goal: goal)
        }
        self.primary?.goal = nil
        try? CoreDataStack.managedObjectContext.save()
    }
    
    func setCompletionPercentage(percentage: Double) {
        
        if let goal = self.primary?.goal {
            goal.percentageCompleted = percentage
        }
        try? CoreDataStack.managedObjectContext.save()
    }
    
    func setCurrentReference(reference: String) {
        
        if let goal = primary?.goal {
            goal.currentReference = reference
        }
        try? CoreDataStack.managedObjectContext.save()
    }
    
    func updatePrimaryGoalLocation(location: [Int]) {
        
        primary?.goal?.currentBook = Int64(location[1])
        primary?.goal?.currentChapter = Int64(location[2])
    }
    
    func invalidateGoal(goal: GoalCD) {
        
        goal.name = "Invalid"
        try? CoreDataStack.managedObjectContext.save()
    }
    
    func delete(goal: GoalCD) {
        
        CoreDataStack.managedObjectContext.delete(goal)
        try? CoreDataStack.managedObjectContext.save()
    }
}
