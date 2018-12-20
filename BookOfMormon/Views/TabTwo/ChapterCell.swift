//
//  ChapterCell.swift
//  BookOfMormon
//
//  Created by Jared Warren on 12/18/18.
//  Copyright © 2018 Warren. All rights reserved.
//

import UIKit

class ChapterCell: UICollectionViewCell {
    
    @IBOutlet weak var chapterLabel: UILabel!
    
    var chapterNumber: Int? {
        didSet {
            updateLabel()
        }
    }
    var isCompleted = false
    
    func updateLabel() {
        
        guard let number = chapterNumber else { return }
        
        chapterLabel.text = String(number)
    }
}
