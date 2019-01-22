//
//  GoalDetailsViewController.swift
//  BookOfMormon
//
//  Created by Jared Warren on 1/14/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import UIKit

class GoalDetailsViewController: UIViewController {
    
    @IBOutlet weak var goalLocationLabel: UILabel!
    @IBOutlet weak var goalFinishDateLabel: UILabel!
    @IBOutlet weak var goalPercentageLabel: UILabel!
    @IBOutlet weak var primaryButton: UIButton!
    
    var goal: GoalCD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.shadowVisibile(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.popToRootViewController(animated: animated)
    }
    
    func setupView() {
        
        self.primaryButton.layer.cornerRadius = primaryButton.frame.height / 2
        
        if let percentage = goal?.percentageCompleted, let reference = goal?.currentReference {
            
            var mutatingPercentage = percentage * 10
            mutatingPercentage = mutatingPercentage.rounded()
            mutatingPercentage = mutatingPercentage / 10
            self.goalLocationLabel.text = "\(reference)"
            self.goalPercentageLabel.text = "\(mutatingPercentage)%"
        }
        
        self.title = goal?.name
        // TODO: Switch on primary?.goal?.testament and unpack depending on whether it's a deadline or daily.
        switch goal?.desiredEndDate == nil {
        case true:
            guard let chapters = goal?.dailyChapters else { return }
            if chapters == 1 {
                goalFinishDateLabel.text = "\(chapters) chapter per day."
            } else {
                goalFinishDateLabel.text = "\(chapters) chapters per day."
            }
        case false:
            guard let endString = goal?.desiredEndDate?.mMdDyY else { return }
            goalFinishDateLabel.text = "Finish by " + endString
        }
        if goal?.isPrimary == true {
            self.primaryButton.isUserInteractionEnabled = false
            self.primaryButton.setTitle("    Primary    ", for: .normal)
        }
    }
    
    @IBAction func primaryButtonTapped(_ sender: Any) {
        
        if let goal = goal {
            GoalController.shared.setDifferentPrimaryGoal(goal: goal)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
