//
//  VerseDetails.swift
//  BookOfMormon
//
//  Created by Jared Warren on 12/31/18.
//  Copyright © 2018 Warren. All rights reserved.
//

import Foundation

class VerseDetails: Equatable {
    
    var verseNote: Note?
    var isHighlighted: Bool
    
    init(verseNote: Note, verseIsHightlighted: Bool) {
        self.verseNote = verseNote
        self.isHighlighted = verseIsHightlighted
    }
    
    static func == (lhs: VerseDetails, rhs: VerseDetails) -> Bool {
        return lhs.verseNote == rhs.verseNote &&
        lhs.isHighlighted == rhs.isHighlighted
    }
}
