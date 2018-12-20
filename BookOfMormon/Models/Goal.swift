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
    var dailyVerses: Int?
    var dailyChapters: Int?
    var dailyPages: Int?
    
    init(name: String, endDate: Date?, currentProgress: Double?, dailyVerses: Int?, dailyChapters: Int?, dailyPages: Int?) {
        
        self.name = name
        self.endDate = endDate
        self.currentProgress = currentProgress
        self.dailyVerses = dailyVerses
        self.dailyChapters = dailyChapters
        self.dailyPages = dailyPages
    }
}
