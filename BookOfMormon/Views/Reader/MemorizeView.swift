//
//  MemorizeView.swift
//  BookOfMormon
//
//  Created by Jared Warren on 1/7/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import UIKit

class MemorizeView: UIView {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var memorizeButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    var verse: VerseCD? {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    @IBAction func closeButtonTapped(_ sender: Any) {
    }
    @IBAction func memorizeButtonTapped(_ sender: Any) {
    }
    @IBAction func addButtonTapped(_ sender: Any) {
        
        leftButton.isHidden = false
        rightButton.isHidden = false
        endLabel.isHidden = false
        addButton.isHidden = true
    }
    
    @IBAction func navigationButtonTapped(_ sender: UIButton) {
    }
    
    func setupView() {
        
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
        closeButton.layer.borderColor = UIColor.lightGray.cgColor
        closeButton.layer.borderWidth = 1
        
        memorizeButton.layer.cornerRadius = memorizeButton.frame.height / 2
        memorizeButton.layer.borderColor = UIColor.lightGray.cgColor
        memorizeButton.layer.borderWidth = 1
        
        addButton.layer.cornerRadius = addButton.frame.height / 2
        addButton.layer.borderColor = UIColor.lightGray.cgColor
        addButton.layer.borderWidth = 1
        
        endLabel.isHidden = true
        leftButton.isHidden = true
        rightButton.isHidden = true
    }
    
    func updateView() {
        startLabel.text = verse?.reference
    }
}
