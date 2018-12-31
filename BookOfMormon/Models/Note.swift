//
//  Note.swift
//  BookOfMormon
//
//  Created by Jared Warren on 12/31/18.
//  Copyright © 2018 Warren. All rights reserved.
//

import Foundation

class Note: Equatable {
    
    var noteLocation: [Int]
    var noteText: String
    
    init(noteLocation: [Int], noteText: String) {
        
        self.noteLocation = noteLocation
        self.noteText = noteText
    }
    
    static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.noteLocation == rhs.noteLocation &&
        lhs.noteText == rhs.noteText
    }
}
