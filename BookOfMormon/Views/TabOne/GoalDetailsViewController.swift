//
//  GoalDetailsViewController.swift
//  BookOfMormon
//
//  Created by Jared Warren on 1/14/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import UIKit

class GoalDetailsViewController: UIViewController {

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
    
    func updateView() {
        
        if let titleKey = goal?.testament {
            
            self.title = TestamentKeys.dictionary[Int(titleKey)]
        }
    }
    
    func setupView() {
        
        
    }
}
