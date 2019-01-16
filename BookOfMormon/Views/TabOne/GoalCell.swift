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
    @IBOutlet weak var firstImageView: UIImageView!
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
        
        self.nameLabel.text = goal?.name
        
        if goal?.dailyChapters == 0 && goal?.desiredEndDate != nil {
            self.secondImageView.image = UIImage(named: "deadline")
        } else if goal?.dailyChapters != 0 && goal?.desiredEndDate == nil {
            self.secondImageView.image = UIImage(named: "daily")
        }
    }
}
