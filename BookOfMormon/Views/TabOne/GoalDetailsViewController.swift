//
//  GoalDetailsViewController.swift
//  BookOfMormon
//
//  Created by Jared Warren on 1/14/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import UIKit

class GoalDetailsViewController: UIViewController {

    @IBOutlet weak var goalNameLabel: UILabel!
    @IBOutlet weak var goalLocationLabel: UILabel!
    @IBOutlet weak var goalFinishDateLabel: UILabel!
    @IBOutlet weak var primaryButton: UIButton!
    
    var goal: GoalCD? {
        didSet {
            updateView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.shadowVisibile(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.popToRootViewController(animated: animated)
    }
    
    func updateView() {
        
        if let titleKey = goal?.testament {
            
            self.title = TestamentKeys.dictionary[Int(titleKey)]
        }
    }
    
    func setupView() {
        
        self.primaryButton.layer.cornerRadius = primaryButton.frame.height / 2
    }
    
    @IBAction func primaryButtonTapped(_ sender: Any) {
        
        
    }
}
