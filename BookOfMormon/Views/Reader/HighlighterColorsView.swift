//
//  HighlighterColorsView.swift
//  BookOfMormon
//
//  Created by Jared Warren on 1/5/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import UIKit

class HighlighterColorsView: UIView {
    
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
    var delegate: ColorViewDelegate?
    
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
        delegate?.updateColorButton()
        closeButtonTapped(sender)
    }
    
    func setupButtons() {
        
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
}

protocol ColorViewDelegate: class {
    func hideSubviews()
    func updateColorButton()
    func colorViewClosed()
}

class Arkin {
    

}
