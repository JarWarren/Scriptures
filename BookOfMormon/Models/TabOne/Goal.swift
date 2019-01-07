//
//  Goal.swift
//  BookOfMormon
//
//  Created by Jared Warren on 12/15/18.
//  Copyright © 2018 Warren. All rights reserved.
//

import Foundation

class Goal: Equatable {
    
    var name: String
    var endDate: Date?
    var startDate: Date
    var currentProgress: Double?
    var dailyChapters: Int?
    var goalTestament: Int
    
    init(name: String, endDate: Date?, startDate: Date, currentProgress: Double?, dailyChapters: Int?, goalTestament: Int) {
        
        self.name = name
        self.endDate = endDate
        self.currentProgress = currentProgress
        self.dailyChapters = dailyChapters
        self.goalTestament = goalTestament
        self.startDate = startDate
    }
    
    static func == (lhs: Goal, rhs: Goal) -> Bool {
        
        return lhs.name == rhs.name &&
            lhs.endDate == rhs.endDate &&
            lhs.startDate == rhs.startDate &&
            lhs.currentProgress == rhs.currentProgress &&
            lhs.dailyChapters == rhs.dailyChapters &&
            lhs.goalTestament == rhs.goalTestament
    }
}
