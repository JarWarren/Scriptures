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
    var verses: MemorizedVersesCD?
    var shouldClose = true
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
        case 1:
            guard let verseHolder = verses else { return }
            guard let unwrappedVerses = verseHolder.verses?.array as? [VerseCD] else { return }
            switch verseHolder.verses?.count {
            case 1:
                guard let verse = unwrappedVerses.first, let text = unwrappedVerses.first?.text else { return }
                titleTextField.text = verse.reference
                bodyTextView.text = "\(verse.verse))  " + text
            default:
                guard let first = unwrappedVerses.first?.reference, let last = unwrappedVerses.last?.reference else { return }
                titleTextField.text = first + " - " + last
                var bodyText = ""
                for verse in unwrappedVerses {
                    if let verseText = verse.text {
                        bodyText.append("\(verse.verse))  ")
                        bodyText.append(verseText)
                        bodyText.append("\n\n")
                    }
                }
                bodyTextView.text = bodyText
            }
            NSLayoutConstraint.activate([entryButton.heightAnchor.constraint(equalToConstant: 50),
                                         entryButton.widthAnchor.constraint(equalToConstant: 50)])
            entryButton.setTitle("", for: .normal)
            entryButton.layer.cornerRadius = 5
            updateMemorizeButton(verses: verseHolder)
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
            guard let verses = verses else { return }
            VerseController.shared.toggleMemorized(verses: verses)
            updateMemorizeButton(verses: verses)
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
    
    func updateMemorizeButton(verses: MemorizedVersesCD) {
        
        if verses.memorized == true {
            entryButton.setBackgroundImage(UIImage(named: "5"), for: .normal)
            completeButton.setTitle("    Not Memorized    ", for: .normal)
            entryButton.layer.borderWidth = 2
            entryButton.layer.borderColor = #colorLiteral(red: 0.6313489079, green: 0.557828486, blue: 0.09932992607, alpha: 1)
        } else {
            entryButton.setBackgroundImage(UIImage(named: "1"), for: .normal)
            completeButton.setTitle("    Memorized    ", for: .normal)
            entryButton.layer.borderWidth = 1
            entryButton.layer.borderColor = UIColor.lightGray.cgColor
        }
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
