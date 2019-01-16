//
//  HighlighterColorController.swift
//  BookOfMormon
//
//  Created by Jared Warren on 1/7/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import UIKit

class HighlighterColorController {
    
    static let shared = HighlighterColorController()
    private init() {}
    var currentColor: UIColor = #colorLiteral(red: 1, green: 0.8203130364, blue: 0.850112617, alpha: 1)
    var currentColorAsInt = 6
    
    func changeColor(to color: Int) {
        
        switch color {
        case 0:
            self.currentColor = #colorLiteral(red: 1, green: 0.5890108943, blue: 0.5542941689, alpha: 1)
        case 1:
            self.currentColor = #colorLiteral(red: 0.9992573857, green: 0.9758862853, blue: 0.6612761021, alpha: 1)
        case 2:
            self.currentColor = #colorLiteral(red: 0.9978972077, green: 0.8612779975, blue: 0.6023510695, alpha: 1)
        case 3:
            self.currentColor = #colorLiteral(red: 1, green: 0.7669227719, blue: 0.9985967278, alpha: 1)
        case 4:
            self.currentColor = #colorLiteral(red: 0.8071166873, green: 0.973033607, blue: 1, alpha: 1)
        case 5:
            self.currentColor = #colorLiteral(red: 0.8644961715, green: 0.5741243958, blue: 0.3978983164, alpha: 1)
        case 6:
            self.currentColor = #colorLiteral(red: 1, green: 0.8203130364, blue: 0.850112617, alpha: 1)
        case 7:
            self.currentColor = #colorLiteral(red: 0.7547509074, green: 0.9932025075, blue: 0.8398650289, alpha: 1)
        case 8:
            self.currentColor = #colorLiteral(red: 0.880623877, green: 0.890354991, blue: 0.9031651616, alpha: 1)
        default:
            self.currentColor = #colorLiteral(red: 1, green: 0.8203130364, blue: 0.850112617, alpha: 1)
        }
        self.currentColorAsInt = color
    }
}
