//
//  TabOne.swift
//  BookOfMormon
//
//  Created by Jared Warren on 12/15/18.
//  Copyright © 2018 Warren. All rights reserved.
//

import UIKit

class TabOne: UIViewController, CurrentGoalViewDelegate {
    
    // MARK: - Outlets and Properties
    @IBOutlet weak var tabOneSegmentedControl: UISegmentedControl!
    var barButton: UIBarButtonItem?
    var chaptersToRead = 0
    var subviews = [UIView]()
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupGoal()
        currentGoalView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabOneSegmentedControl.selectedSegmentIndex = 0
    }
    
    // MARK: - Setup Methods
    func setupButtons() {
        
        barButton = navigationItem.rightBarButtonItem
        guard let barButton = barButton else { return }
        barButton.target = self
        barButton.action = #selector(recalculateButtonTapped)
    }
    
    
    // MARK: Goal Stats
    func setupGoal() {
        
        //        if var timeLeft = GoalController.shared.currentGoal?.endDate?.timeIntervalSinceNow,
        //            let goalTestament = GoalController.shared.currentGoal?.goalTestament {
        //
        //            timeLeft = (timeLeft / 86400).rounded(.down)
        //            print(timeLeft)
        //            let testamentChapters = TestamentKeys.chapters[goalTestament]
        //            print(testamentChapters! / timeLeft)
        //        }
    }
    
    func hideSubviews() {
        
        for view in subviews {
            view.isHidden = true
        }
        subviews.removeAll()
    }
    
    func currentGoalView() {
        
        guard let currentGoalView = Bundle.main.loadNibNamed("CurrentGoal", owner: nil, options: nil)![0] as? CurrentGoalView else { return }
        tabOneSegmentedControl.selectedSegmentIndex = 0
        currentGoalView.delegate = self
        self.view.addSubview(currentGoalView)
        subviews.append(currentGoalView)
        currentGoalView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currentGoalView.topAnchor.constraint(equalTo: tabOneSegmentedControl.bottomAnchor, constant: 1),
            currentGoalView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            currentGoalView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            currentGoalView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)])
    }
    
    func newGoalView() {
        
        guard let newGoalView = Bundle.main.loadNibNamed("NewGoal", owner: nil, options: nil)![0] as? NewGoalView else { return }
        self.view.addSubview(newGoalView)
        subviews.append(newGoalView)
        newGoalView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newGoalView.topAnchor.constraint(equalTo: tabOneSegmentedControl.bottomAnchor, constant: 1),
            newGoalView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            newGoalView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            newGoalView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)])
    }
    
    // MARK: Actions
    @IBAction func tabOneSegmentedControlValueChanged(_ sender: Any) {
        
        hideSubviews()
        switch tabOneSegmentedControl.selectedSegmentIndex {
        case 0:
            currentGoalView()
        case 1:
            newGoalView()
        case 2: return
        default: tabOneSegmentedControl.selectedSegmentIndex = 0
        }
    }
    
    
    @IBAction func recalculateButtonTapped(_ sender: Any) {
        
    }
    
    // MARK: - Navigation
    func segueToReader() {
        
        guard let destinationTestament = GoalController.shared.currentGoal?.testament,
            let destinationBook = GoalController.shared.currentGoal?.currentBook,
            let destinationChapter = GoalController.shared.currentGoal?.currentChapter else {
                tabOneSegmentedControl.selectedSegmentIndex = 1
                tabOneSegmentedControl.sendActions(for: .valueChanged)
                return
        }
        ScriptureController.shared.selectedTestament = TestamentKeys.selectedTestament[Int(destinationTestament)]
        ScriptureController.shared.change(testament: ScriptureController.shared.selectedTestament ?? TestamentKeys.BoM) { (_) in
            
            let readingViewController = UIStoryboard(name: "Reader", bundle: nil).instantiateViewController(withIdentifier: "ReadingViewController") as! ReadingViewController
            readingViewController.currentBook = Int(destinationBook)
            readingViewController.currentChapter = Int(destinationChapter)
            
            self.navigationController?.pushViewController(readingViewController, animated: true)
        }
    }
}
