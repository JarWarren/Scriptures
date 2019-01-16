//
//  CurrentGoalView.swift
//  BookOfMormon
//
//  Created by Jared Warren on 1/8/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import UIKit

class CurrentGoalView: UIView {
    
    @IBOutlet weak var todayButton: UIButton!
    var delegate: CurrentGoalViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    func setupView() {
        
        todayButton.layer.cornerRadius = todayButton.frame.height / 2
        guard let currentReference = GoalController.shared.primaryGoal?.currentReference else { return }
        todayButton.setTitle("    \(currentReference)    ", for: .normal)
    }
    
    @IBAction func todayButtonTapped(_ sender: Any) {
        
        delegate?.segueToReader()
    }
}

protocol CurrentGoalViewDelegate: class {
    
    func segueToReader()
}
