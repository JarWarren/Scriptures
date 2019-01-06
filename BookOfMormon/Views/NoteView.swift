//
//  NoteView.swift
//  BookOfMormon
//
//  Created by Jared Warren on 1/4/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import UIKit

class NoteView: UIView, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var noteDateLabel: UILabel!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    var verse: VerseCD? {
        didSet {
            updateView()
        }
    }
    var isEditing = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateView()
        exitButton.layer.cornerRadius = exitButton.frame.height / 2
        exitButton.layer.shadowColor = UIColor.black.cgColor
        exitButton.layer.shadowRadius = 2
        editButton.layer.cornerRadius = editButton.frame.height / 2
        editButton.layer.shadowColor = UIColor.black.cgColor
        editButton.layer.shadowRadius = 2
        deleteButton.layer.cornerRadius = deleteButton.frame.height / 2
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
    
        switch self.isEditing {
        case false:
            editButton.setTitle("   Save   ", for: .normal)
            editButton.backgroundColor = #colorLiteral(red: 0, green: 0.5016700625, blue: 0.005194439087, alpha: 1)
            noteTextField.backgroundColor = UIColor.white
            bodyTextView.backgroundColor = UIColor.white
            noteTextField.isUserInteractionEnabled = true
            bodyTextView.isUserInteractionEnabled = true
            self.isEditing = !self.isEditing
        case true:
            guard let noteTitle = noteTextField.text, noteTextField.text?.isEmpty == false,
                let noteBody = bodyTextView.text, bodyTextView.text.isEmpty == false,
            let verse = self.verse else { return }
            editButton.setTitle("   Edit   ", for: .normal)
            editButton.backgroundColor = #colorLiteral(red: 0.006345573347, green: 0.478813827, blue: 0.9984634519, alpha: 1)
            noteTextField.backgroundColor = #colorLiteral(red: 0.9646112323, green: 0.964772284, blue: 0.9645897746, alpha: 1)
            bodyTextView.backgroundColor = #colorLiteral(red: 0.9646112323, green: 0.964772284, blue: 0.9645897746, alpha: 1)
            noteTextField.isUserInteractionEnabled = false
            bodyTextView.isUserInteractionEnabled = false
            NoteController.addNoteTo(verse: verse, title: noteTitle, body: noteBody)
            self.isEditing = !self.isEditing
        }
    }
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        
        self.isHidden = true
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        if let verse = self.verse {
        NoteController.deleteNoteFrom(verse: verse)
            exitButtonTapped(sender)
        }
    }
    
    func updateView() {
        if let title = verse?.noteTitle, let text = verse?.noteText, let date = verse?.noteDate {
            let DF = DateFormatter()
            DF.dateFormat = "MM-DD-YY"
            let time = DF.string(from: date)
            noteDateLabel.text = time
            noteTextField.text = title
            bodyTextView.text = text
            editButton.setTitle("   Edit   ", for: .normal)
            editButton.backgroundColor = #colorLiteral(red: 0.006345573347, green: 0.478813827, blue: 0.9984634519, alpha: 1)
            noteTextField.backgroundColor = #colorLiteral(red: 0.9646112323, green: 0.964772284, blue: 0.9645897746, alpha: 1)
            bodyTextView.backgroundColor = #colorLiteral(red: 0.9646112323, green: 0.964772284, blue: 0.9645897746, alpha: 1)
            noteTextField.isUserInteractionEnabled = false
            bodyTextView.isUserInteractionEnabled = false
            self.isEditing = false
        } else {
            editButton.setTitle("   Save   ", for: .normal)
            editButton.backgroundColor = #colorLiteral(red: 0, green: 0.5016700625, blue: 0.005194439087, alpha: 1)
            noteTextField.backgroundColor = UIColor.white
            bodyTextView.backgroundColor = UIColor.white
        }
    }
}
