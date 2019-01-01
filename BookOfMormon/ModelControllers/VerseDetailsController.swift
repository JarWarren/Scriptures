//
//  VerseDetailsController.swift
//  BookOfMormon
//
//  Created by Jared Warren on 12/31/18.
//  Copyright © 2018 Warren. All rights reserved.
//

import Foundation

class VerseDetailsController {
    
    static let shared = VerseDetailsController()
    var allVerseDetails = [VerseDetails]()
    private init() {}
    
    func addNoteToVerse(location: [Int], text: String, isHighlighted: Bool) {
        
        let newNote = Note(noteLocation: location, noteText: text)
        let newVerseDetails = VerseDetails(verseNote: newNote, verseIsHightlighted: isHighlighted)
        allVerseDetails.append(newVerseDetails)
    }
    
    func updateVerse(verse: VerseDetails, note: Note, location: [Int], text: String, isHighlighted: Bool) {
        
        let newNote = note
        newNote.noteLocation = location
        newNote.noteText = text
        verse.verseNote = newNote
        verse.isHighlighted = isHighlighted
    }
    
    func deleteVerseDetails(verse: VerseDetails) {
        
        guard let deadVerse = allVerseDetails.firstIndex(of: verse) else { return }
        allVerseDetails.remove(at: deadVerse)
    }
}
