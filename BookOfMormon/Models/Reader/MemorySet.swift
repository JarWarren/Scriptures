//
//  MemorySet.swift
//  BookOfMormon
//
//  Created by Jared Warren on 1/14/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import Foundation

class MemorySet: Equatable, Codable {
    
    var isMemorized: Bool
    var verseInts: [Int]
    var verseReferences: [String]
    var verseTexts: [String]
    
    init(verseInts: [Int], verseReferences: [String], verseTexts: [String]) {
        
        self.isMemorized = false
        self.verseInts = verseInts
        self.verseReferences = verseReferences
        self.verseTexts = verseTexts
    }
    
    static func == (lhs: MemorySet, rhs: MemorySet) -> Bool {
        
        return lhs.verseInts == rhs.verseInts &&
        lhs.verseReferences == rhs.verseReferences &&
        lhs.verseTexts == rhs.verseTexts
    }
}
