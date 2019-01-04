//
//  NoteView.swift
//  BookOfMormon
//
//  Created by Jared Warren on 1/4/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import UIKit

class NoteView: UIView {
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    var verse: VerseCD?
    var isEditing = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let title = verse?.noteTitle, let text = verse?.noteText , let date = verse?.noteDate {
            let DF = DateFormatter()
            DF.dateFormat = "MM-DD-YY"
            let time = DF.string(from: date)
            noteTextField.text = title
            bodyTextView.text = "\(time)\n\n" + text
            noteTextField.isUserInteractionEnabled = false
            bodyTextView.isUserInteractionEnabled = false
            self.isEditing = false
        } else {
            editButton.setTitle("   Save   ", for: .normal)
            editButton.setTitleColor(#colorLiteral(red: 0, green: 0.5016700625, blue: 0.005194439087, alpha: 1), for: .normal)
            noteTextField.backgroundColor = UIColor.white
            bodyTextView.backgroundColor = UIColor.white
        }
        
        editButton.layer.cornerRadius = editButton.frame.height / 2
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
    
        switch self.isEditing {
        case true:
            editButton.setTitle("   Save   ", for: .normal)
            editButton.setTitleColor(#colorLiteral(red: 0, green: 0.5016700625, blue: 0.005194439087, alpha: 1), for: .normal)
            noteTextField.backgroundColor = UIColor.white
            bodyTextView.backgroundColor = UIColor.white
            noteTextField.isUserInteractionEnabled = true
            bodyTextView.isUserInteractionEnabled = true
        case false:
            editButton.setTitle("   Edit   ", for: .normal)
            editButton.setTitleColor(#colorLiteral(red: 0.006345573347, green: 0.478813827, blue: 0.9984634519, alpha: 1), for: .normal)
            noteTextField.backgroundColor = #colorLiteral(red: 0.9646112323, green: 0.964772284, blue: 0.9645897746, alpha: 1)
            bodyTextView.backgroundColor = #colorLiteral(red: 0.9646112323, green: 0.964772284, blue: 0.9645897746, alpha: 1)
            noteTextField.isUserInteractionEnabled = false
            bodyTextView.isUserInteractionEnabled = false
        }
        self.isEditing = !self.isEditing
    }
}
