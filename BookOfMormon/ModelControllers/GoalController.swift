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
    
    func createGoal(name: String, endDate: Date?, verses: Int? = 0, chapters: Int? = 0, pages: Int? = 0) {
        
        let newGoal = Goal(name: name, endDate: endDate, currentProgress: nil, dailyVerses: verses, dailyChapters: chapters, dailyPages: pages)
        allGoals.append(newGoal)
    }
    
    func delete(goal: Goal) {
        
        
    }
}
