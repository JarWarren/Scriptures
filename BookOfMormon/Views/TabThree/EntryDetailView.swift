//
//  EntryDetailView.swift
//  BookOfMormon
//
//  Created by Jared Warren on 1/5/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import UIKit

class EntryDetailView: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var entryButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var completeButton: UIButton!
    var entry: EntryCD?
    var shouldClose = true
    var isMemorized: Bool?
    var titleText: String?
    var bodyText: String?
    var masteryTestament: Int?
    var parentSelectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.popToRootViewController(animated: animated)
    }
    
    func setupView() {
        
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.6313489079, green: 0.557828486, blue: 0.09932992607, alpha: 1)
        completeButton.layer.cornerRadius = completeButton.frame.height / 2
        completeButton.layer.borderColor = UIColor.lightGray.cgColor
        completeButton.layer.borderWidth = 1
        entryButton.isUserInteractionEnabled = false
        titleTextField.layer.cornerRadius = 5
        titleTextField.delegate = self
        bodyTextView.layer.cornerRadius = 5
        bodyTextView.delegate = self
        
        switch parentSelectedIndex {
        case 0:
            if let entry = entry {
                titleTextField.text = entry.entryTitle; bodyTextView.text = entry.entryText; entryButton.setTitle(entry.entryDate?.mMdDyY, for: .normal)
                titleTextField.isUserInteractionEnabled = false
                bodyTextView.isUserInteractionEnabled = false
                completeButton.setTitle("    Edit    ", for: .normal)
            } else {
                prepareToEdit()
            }
        case 1: return
        case 2: return
        default: return
        }
    }
    
    @IBAction func completeButtonTapped(_ sender: Any) {
        
        switch parentSelectedIndex {
        case 0:
            if let entryTitle = titleTextField.text, titleTextField.text?.isEmpty == false,
                let entryBody = bodyTextView.text, bodyTextView.text.isEmpty == false, shouldClose == true {
                if let entry = entry {
                    EntryController.shared.updateEntry(entry: entry, title: entryTitle, text: entryBody)
                } else {
                    EntryController.shared.createNewEntry(title: entryTitle, text: entryBody)
                }
                navigationController?.popToRootViewController(animated: true)
            } else {
                prepareToEdit()
            }
        case 1:
            print("mark memorizable scripture as memorized/not")
        case 2:
            print("mark memorizable mastery as memorized/not")
        default: return
        }
    }
    
    func prepareToEdit() {
        titleTextField.backgroundColor = UIColor.white
        titleTextField.layer.borderWidth = 1
        titleTextField.layer.borderColor = UIColor.lightGray.cgColor
        titleTextField.isUserInteractionEnabled = true
        bodyTextView.backgroundColor = UIColor.white
        bodyTextView.layer.borderColor = UIColor.lightGray.cgColor
        bodyTextView.layer.borderWidth = 1
        bodyTextView.isUserInteractionEnabled = true
        entryButton.isHidden = true
        completeButton.setTitle("    Save    ", for: .normal)
        self.shouldClose = true
    }
    
    // MARK: Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        bodyTextView.becomeFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            
            // TODO: Find a way to allow linebreaks and resigning first responder both. Not just one or the other.
        }
        return true
    }
}
