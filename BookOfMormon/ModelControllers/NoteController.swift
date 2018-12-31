//
//  NoteController.swift
//  BookOfMormon
//
//  Created by Jared Warren on 12/31/18.
//  Copyright © 2018 Warren. All rights reserved.
//

import Foundation

class NoteController {
    
    static let shared = NoteController()
    var allNotes = [Note]()
    private init() {}
    
    func createNote(location: [Int], text: String) {
        
        let newNote = Note(noteLocation: location, noteText: text)
        allNotes.append(newNote)
    }
    
    func updateNote(note: Note, location: [Int], text: String) {
        
        note.noteLocation = location
        note.noteText = text
    }
    
    func deleteNote(note: Note) {
        
        guard let dyingNoteIndex = allNotes.firstIndex(of: note) else { return }
        allNotes.remove(at: dyingNoteIndex)
    }
}
