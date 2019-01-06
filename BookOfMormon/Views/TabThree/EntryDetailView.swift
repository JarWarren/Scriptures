//
//  EntryDetailView.swift
//  BookOfMormon
//
//  Created by Jared Warren on 1/5/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import UIKit

class EntryDetailView: UIViewController {

    @IBOutlet weak var entryButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var completeButton: UIButton!
    var barButton: UIBarButtonItem?
    var titleText: String?
    var bodyText: String?
    var date: Date?
    var isMemorized: Bool?
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
        bodyTextView.layer.cornerRadius = 5
        
        switch parentSelectedIndex {
        case 0:
            if let text = self.titleText, let body = bodyText, let date = date {
                titleTextField.text = text; bodyTextView.text = body; entryButton.setTitle(date.mMdDyY, for: .normal)
                titleTextField.isUserInteractionEnabled = false
                bodyTextView.isUserInteractionEnabled = false
                self.barButton = navigationItem.rightBarButtonItem
                barButton?.title = "Edit"
                barButton?.target = self
                barButton?.action = #selector(barButtonTapped)
            } else {
                titleTextField.backgroundColor = UIColor.white
                bodyTextView.backgroundColor = UIColor.white
                entryButton.isHidden = true
                self.barButton = navigationItem.rightBarButtonItem
                barButton?.title = "Save"
                barButton?.target = self
                barButton?.action = #selector(barButtonTapped)
            }
        case 1: return
        case 2: return
        default: return
        }
    }
    
    @objc func barButtonTapped(_ sender: Any) {
        
        
    }
    
    @IBAction func completeButtonTapped(_ sender: Any) {
        
        switch parentSelectedIndex {
        case 0:
            guard let entryTitle = titleTextField.text, titleTextField.text?.isEmpty == false,
                let entryBody = bodyTextView.text, bodyTextView.text.isEmpty == false else { return }
            EntryController.shared.createNewEntry(title: entryTitle, text: entryBody)
            navigationController?.popToRootViewController(animated: true)
        case 1:
            print("mark memorizable scripture as memorized/not")
        case 2:
            print("mark memorizable mastery as memorized/not")
        default: return
        }
    }
}
