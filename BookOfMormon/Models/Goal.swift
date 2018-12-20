//
//  Goal.swift
//  BookOfMormon
//
//  Created by Jared Warren on 12/15/18.
//  Copyright © 2018 Warren. All rights reserved.
//

import Foundation

class Goal {
    
    var name: String
    var endDate: Date?
    var currentProgress: Double?
    var dailyChapters: Int?
    var goalTestament: Int
    
    init(name: String, endDate: Date?, currentProgress: Double?, dailyChapters: Int?, goalTestament: Int) {
        
        self.name = name
        self.endDate = endDate
        self.currentProgress = currentProgress
        self.dailyChapters = dailyChapters
        self.goalTestament = goalTestament
    }
}
