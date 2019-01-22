//
//  MemorizeCell.swift
//  BookOfMormon
//
//  Created by Jared Warren on 1/7/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import UIKit

class MemorizeCell: UITableViewCell {
    
    @IBOutlet weak var referenceLabel: UILabel!
    @IBOutlet weak var memorizedImage: UIImageView!
    var memorySet: MemorySet? {
        didSet {
            updateCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateCell() {
        guard let currentSet = memorySet else { return }
        switch currentSet.verseInts.count {
        case 1:
            guard let onlyVerse = currentSet.verseReferences.first else { return }
            referenceLabel.text = onlyVerse
        default:
            guard let first = currentSet.verseReferences.first, let last = currentSet.verseReferences.last else { return }
            referenceLabel.text = first + " - " + last
        }
        setupImage()
    }
    
    func setupImage() {
        
        memorizedImage.backgroundColor = UIColor.white
        switch memorySet?.isMemorized {
        case true:
            self.memorizedImage.image = UIImage(named: "memorized")
            memorizedImage.layer.borderColor = #colorLiteral(red: 0.6313489079, green: 0.557828486, blue: 0.09932992607, alpha: 1)
            memorizedImage.layer.borderWidth = 2
            memorizedImage.tintColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        case false:
            self.memorizedImage.image = UIImage(named: "notMemorized")
            memorizedImage.layer.borderColor = UIColor.black.cgColor
            memorizedImage.layer.borderWidth = 1
            memorizedImage.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        default: return
        }
        memorizedImage.layer.cornerRadius = 5
    }
}
