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
    weak var delegate: NoteViewDelegate?
    var verse: VerseCD? {
        didSet {
            updateView()
        }
    }
    var isEditing = true {
        didSet {
            switch isEditing {
            case true:
                noteTextField.layer.borderWidth = 1
                noteTextField.layer.borderColor = UIColor.lightGray.cgColor
                bodyTextView.layer.borderWidth = 1
                bodyTextView.layer.borderColor = UIColor.lightGray.cgColor
            case false:
                return
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateView()
        noteTextField.layer.cornerRadius = 5
        bodyTextView.layer.cornerRadius = 5
        exitButton.layer.cornerRadius = exitButton.frame.height / 2
        exitButton.layer.borderWidth = 1
        exitButton.layer.borderColor = UIColor.lightGray.cgColor
        editButton.layer.cornerRadius = editButton.frame.height / 2
        editButton.layer.borderWidth = 1
        editButton.layer.borderColor = UIColor.lightGray.cgColor
        deleteButton.layer.cornerRadius = deleteButton.frame.height / 2
        deleteButton.layer.borderWidth = 1
        deleteButton.layer.borderColor = UIColor.lightGray.cgColor
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
            exitButtonTapped(sender)
            guard let noteTitle = noteTextField.text,
                let noteBody = bodyTextView.text,
                noteTextField.text != nil || bodyTextView.text != nil,
                let verse = self.verse else { return }
            noteTextField.isUserInteractionEnabled = false
            bodyTextView.isUserInteractionEnabled = false
            VerseController.addNoteTo(verse: verse, title: noteTitle, body: noteBody)
        }
    }
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        delegate?.noteViewIsVisible = false
        delegate?.hideSubviews()
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        if let verse = self.verse {
            VerseController.deleteNoteFrom(verse: verse)
            exitButtonTapped(sender)
        }
    }
    
    func updateView() {
        if let title = verse?.noteTitle, let text = verse?.noteText, let date = verse?.noteDate {
            noteDateLabel.text = date.mMdDyY
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

protocol NoteViewDelegate: class {
    var noteViewIsVisible: Bool { get set }
    func hideSubviews()
}
