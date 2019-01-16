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
    var memorySet: MemorySet?
    var shouldClose = true
    var masteryTestament: Int?
    var parentSelectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.shadowVisibile(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.popToRootViewController(animated: animated)
    }
    
    func setupView() {
        
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.6313489079, green: 0.557828486, blue: 0.09932992607, alpha: 1)
        completeButton.layer.cornerRadius = completeButton.frame.height / 2
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
            guard let currentSet = memorySet else { abortView(); return }
            switch currentSet.verseInts.count {
            case 1:
                guard let text = currentSet.verseTexts.first,
                    let number = currentSet.verseInts.first,
                    let reference = currentSet.verseReferences.first else { abortView(); return }
                titleTextField.text = reference
                bodyTextView.text = "\(number))  " + text
            default:
                guard let first = currentSet.verseReferences.first, let last = currentSet.verseReferences.last else { abortView(); return }
                titleTextField.text = first + " - " + last
                var bodyText = ""
                for text in currentSet.verseTexts {
                    bodyText.append("\(currentSet.verseInts[currentSet.verseTexts.firstIndex(of: text) ?? 0]))  ")
                        bodyText.append(text)
                        bodyText.append("\n\n")
                }
                bodyTextView.text = bodyText
            }
            NSLayoutConstraint.activate([entryButton.heightAnchor.constraint(equalToConstant: 50),
                                         entryButton.widthAnchor.constraint(equalToConstant: 50)])
            entryButton.setTitle("", for: .normal)
            entryButton.layer.cornerRadius = 5
            updateMemorizeButton(memorySet: currentSet)
        case 2: return
        default: return
        }
    }
    
    @IBAction func entryButtonTapped(_ sender: Any) {
        
        titleTextField.resignFirstResponder()
        bodyTextView.resignFirstResponder()
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
            guard let currentSet = memorySet else { abortView(); return }
            MemorySetController.shared.toggleMemorySetStatus(memorySet: currentSet)
            updateMemorizeButton(memorySet: currentSet)
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
        entryButton.setTitle("    Return    ", for: .normal)
        entryButton.isUserInteractionEnabled = true
        entryButton.backgroundColor = #colorLiteral(red: 0.6313489079, green: 0.557828486, blue: 0.09932992607, alpha: 1)
        entryButton.layer.cornerRadius = entryButton.frame.height / 2
        entryButton.setTitleColor(UIColor.white, for: .normal)
        completeButton.setTitle("    Save    ", for: .normal)
        self.shouldClose = true
    }
    
    func updateMemorizeButton(memorySet: MemorySet) {
        
        if memorySet.isMemorized == true {
            entryButton.setBackgroundImage(UIImage(named: "memorized"), for: .normal)
            entryButton.tintColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            entryButton.backgroundColor = UIColor.white
            completeButton.setTitle("    Not Memorized    ", for: .normal)
            entryButton.layer.borderWidth = 3
            entryButton.layer.borderColor = #colorLiteral(red: 0.6313489079, green: 0.557828486, blue: 0.09932992607, alpha: 1)
        } else {
            entryButton.setBackgroundImage(UIImage(named: "notMemorized"), for: .normal)
            entryButton.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            completeButton.setTitle("    Memorized    ", for: .normal)
            entryButton.layer.borderWidth = 1
            entryButton.layer.borderColor = UIColor.black.cgColor
            entryButton.backgroundColor = UIColor.white
        }
    }
    
    // MARK: Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        bodyTextView.becomeFirstResponder()
        return true
    }
    
    func abortView() {
        
        //        self.navigationController?.popToRootViewController(animated: true)
    }
}
