//
//  HighlighterColors.swift
//  BookOfMormon
//
//  Created by Jared Warren on 1/5/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import UIKit

class HighlighterColors: UIView {
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupButtons()
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        
        self.isHidden = true
    }
    
    func setupButtons() {
        
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
        closeButton.layer.borderWidth = 1
        closeButton.layer.borderColor = UIColor.lightGray.cgColor
        
        colorOne.layer.cornerRadius = 5
        colorOne.layer.borderWidth = 1
        colorOne.layer.borderColor = UIColor.lightGray.cgColor
        
        colorTwo.layer.cornerRadius = 5
        colorTwo.layer.borderWidth = 1
        colorTwo.layer.borderColor = UIColor.lightGray.cgColor
        
        colorThree.layer.cornerRadius = 5
        colorThree.layer.borderWidth = 1
        colorThree.layer.borderColor = UIColor.lightGray.cgColor
        
        colorFour.layer.cornerRadius = 5
        colorFour.layer.borderWidth = 1
        colorFour.layer.borderColor = UIColor.lightGray.cgColor
        
        colorFive.layer.cornerRadius = 5
        colorFive.layer.borderWidth = 1
        colorFive.layer.borderColor = UIColor.lightGray.cgColor
        
        colorSix.layer.cornerRadius = 5
        colorSix.layer.borderWidth = 1
        colorSix.layer.borderColor = UIColor.lightGray.cgColor
        
        colorSeven.layer.cornerRadius = 5
        colorSeven.layer.borderWidth = 1
        colorSeven.layer.borderColor = UIColor.lightGray.cgColor
        
        colorEight.layer.cornerRadius = 5
        colorEight.layer.borderWidth = 1
        colorEight.layer.borderColor = UIColor.lightGray.cgColor
        
        colorNine.layer.cornerRadius = 5
        colorNine.layer.borderWidth = 1
        colorNine.layer.borderColor = UIColor.lightGray.cgColor
    }
}
