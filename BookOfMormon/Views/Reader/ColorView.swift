//
//  ColorView.swift
//  BookOfMormon
//
//  Created by Jared Warren on 1/5/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import UIKit

class ColorView: UIView {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var colorOne: UIButton!
    @IBOutlet weak var colorTwo: UIButton!
    @IBOutlet weak var colorThree: UIButton!
    @IBOutlet weak var colorFour: UIButton!
    @IBOutlet weak var colorFive: UIButton!
    @IBOutlet weak var colorSix: UIButton!
    @IBOutlet weak var colorSeven: UIButton!
    @IBOutlet weak var colorEight: UIButton!
    @IBOutlet weak var colorNine: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    var delegate: ColorViewDelegate?
    var entry: EntryCD? {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupButtons()
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        delegate?.hideSubviews()
        delegate?.colorViewClosed()
    }
    
    @IBAction func colorButtonTapped(_ sender: UIButton) {
        
        HighlighterColorController.shared.changeColor(to: sender.tag)
        delegate?.updateColor()
        closeButtonTapped(sender)
        guard let entry = entry else { return }
        EntryController.shared.changeEntryCategory(entry: entry, category: sender.tag)
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        
        closeButtonTapped(sender)
        guard let entry = entry else { return }
        EntryController.shared.changeEntryCategory(entry: entry, category: 10)
    }
    
    func setupButtons() {
        
        clearButton.isHidden = true
        
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
        
        colorOne.layer.cornerRadius = 5
        
        colorTwo.layer.cornerRadius = 5
        
        colorThree.layer.cornerRadius = 5
        
        colorFour.layer.cornerRadius = 5
        
        colorFive.layer.cornerRadius = 5
        
        colorSix.layer.cornerRadius = 5
        
        colorSeven.layer.cornerRadius = 5
        
        colorEight.layer.cornerRadius = 5
        
        colorNine.layer.cornerRadius = 5
    }
    
    func updateView() {
        
        clearButton.layer.cornerRadius = clearButton.frame.height / 2
        clearButton.isHidden = false
    }
}

protocol ColorViewDelegate: class {
    func hideSubviews()
    func updateColor()
    func colorViewClosed()
}
