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
    var parentSelectedIndex: Int? {
        didSet {
            if parentSelectedIndex == 0 {
                switch self.titleText == nil {
                case true:
                    let barItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(barButtonTapped))
                    self.barButton = barItem
                case false:
                    let barItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(barButtonTapped))
                    self.barButton = barItem
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.popToRootViewController(animated: animated)
    }
    
    func setupView() {
        
        completeButton.layer.cornerRadius = completeButton.frame.height / 2
        completeButton.layer.borderColor = UIColor.lightGray.cgColor
        completeButton.layer.borderWidth = 1
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.6313489079, green: 0.557828486, blue: 0.09932992607, alpha: 1)
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
