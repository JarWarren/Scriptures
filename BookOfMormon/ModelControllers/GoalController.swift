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
    var currentGoal: Goal?
    
    func createGoal(name: String, endDate: Date?, chapters: Int? = 0, testament: Int) {
        
        let newGoal = Goal(name: name, endDate: endDate, currentProgress: nil, dailyChapters: chapters, goalTestament: testament)
        allGoals.append(newGoal)
    }
    
    func delete(goal: Goal) {
        
        
    }
}
