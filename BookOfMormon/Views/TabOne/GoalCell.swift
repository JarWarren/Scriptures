//
//  GoalCell.swift
//  BookOfMormon
//
//  Created by Jared Warren on 1/8/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import UIKit

class GoalCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var secondImageView: UIImageView!
    var goal: GoalCD? {
        didSet {
            updateCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateCell() {
        if let name = goal?.name, let testamentKey = goal?.testament {
            guard let testament = TestamentKeys.abbreviations[testamentKey] else { return }
            self.nameLabel.text = name + " - " + testament
        }
        
        if goal?.dailyChapters == 0 && goal?.desiredEndDate != nil {
            self.secondImageView.image = UIImage(named: "deadline")
        } else if goal?.dailyChapters != 0 && goal?.desiredEndDate == nil {
            self.secondImageView.image = UIImage(named: "daily")
        }
        
        if goal?.isPrimary == true {
            self.backgroundColor = #colorLiteral(red: 0.8529085517, green: 1, blue: 0.7356277108, alpha: 1)
        } else {
            self.backgroundColor = UIColor.white
        }
    }
}
