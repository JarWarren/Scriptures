//
//  GoalController.swift
//  BookOfMormon
//
//  Created by Jared Warren on 12/15/18.
//  Copyright © 2018 Warren. All rights reserved.
//

import Foundation

class GoalController {
    
    static let shared = GoalController()
    private init() {}
    var allGoals = [Goal]()
    var currentGoal: Goal? {
        return self.allGoals.first
    }
    
    func createGoal(name: String, endDate: Date?, startDate: Date, chapters: Int? = 0, testament: Int) {
        
        let newGoal = Goal(name: name, endDate: endDate, startDate: startDate, currentProgress: nil, dailyChapters: chapters, goalTestament: testament)
        allGoals.append(newGoal)
    }
    
    func delete(goal: Goal) {
        
        guard let deadGoal = allGoals.firstIndex(of: goal) else { return }
        allGoals.remove(at: deadGoal)
    }
}
