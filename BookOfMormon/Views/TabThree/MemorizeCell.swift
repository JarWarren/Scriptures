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
    var memorizedVerseSet: MemorizedVersesCD? {
        didSet {
            updateCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateCell() {
        guard let verses = memorizedVerseSet?.verses?.array as? [VerseCD] else { return }
        switch verses.count {
        case 1:
            guard let onlyVerse = verses.first?.reference else { return }
            referenceLabel.text = onlyVerse
        default:
            guard let first = verses.first?.reference, let last = verses.last?.reference else { return }
            referenceLabel.text = first + " - " + last
        }
        setupImage()
    }
    
    func setupImage() {
        
        switch memorizedVerseSet?.memorized {
        case true:
            self.memorizedImage.image = UIImage(named: "5")
            memorizedImage.layer.borderColor = #colorLiteral(red: 0.6313489079, green: 0.557828486, blue: 0.09932992607, alpha: 1)
            memorizedImage.layer.borderWidth = 2
        case false:
            self.memorizedImage.image = UIImage(named: "1")
            memorizedImage.layer.borderColor = UIColor.lightGray.cgColor
            memorizedImage.layer.borderWidth = 1
        default: return
        }
        memorizedImage.layer.cornerRadius = 5
    }
}
