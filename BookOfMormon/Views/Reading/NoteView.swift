//
//  NoteView.swift
//  BookOfMormon
//
//  Created by Jared Warren on 12/31/18.
//  Copyright © 2018 Warren. All rights reserved.
//

import UIKit

class NoteView: UIView {
    
    @IBOutlet weak var bodyTextView: UITextView!
    var isBeingEdited = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateView()
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        
        self.isBeingEdited = !isBeingEdited
    }
    
    func updateView() {
        
        switch isBeingEdited {
        case true:
            bodyTextView.isEditable = true
        case false:
            bodyTextView.isEditable = false
        }
    }
}
