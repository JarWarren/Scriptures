//
//  TabOne.swift
//  BookOfMormon
//
//  Created by Jared Warren on 12/15/18.
//  Copyright © 2018 Warren. All rights reserved.
//

import UIKit

class TabOne: UIViewController {
    
    // MARK: - Outlets and Properties
    @IBOutlet weak var todayReadingButton: UIButton!
    var barButton: UIBarButtonItem?
    // TODO: - Add border to only one side of each button.
    var menuIsOpen = false
    var chaptersToRead = 0
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupGoal()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissMenu()
    }
    
    // MARK: - Setup Methods
    func setupButtons() {
        
        todayReadingButton.layer.cornerRadius = todayReadingButton.frame.height/2
        todayReadingButton.layer.borderWidth = 1
        todayReadingButton.layer.borderColor = UIColor.lightGray.cgColor
        barButton = navigationItem.rightBarButtonItem
        
        guard let barButton = barButton
            else { return }
        barButton.target = self
        barButton.action = #selector(menuButtonTapped)
    }
    
    
    // MARK: Goal Stats
    func setupGoal() {
        
        if var timeLeft = GoalController.shared.currentGoal?.endDate?.timeIntervalSinceNow,
            let goalTestament = GoalController.shared.currentGoal?.goalTestament {
            
            timeLeft = (timeLeft / 86400).rounded(.down)
            print(timeLeft)
            let testamentChapters = TestamentKeys.chapters[goalTestament]
            print(testamentChapters! / timeLeft)
        }
    }
    
    // MARK: Menu
    @objc func menuButtonTapped() {
        
        switch menuIsOpen {
        case false:
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveLinear], animations: {
                
            }, completion: nil)
            self.menuIsOpen = true
        case true:
            dismissMenu()
        }
    }
    
    func dismissMenu() {
        guard menuIsOpen == true else { return }
        self.menuIsOpen = false
    }
    
    @IBAction func recalculateButtonTapped(_ sender: Any) {
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destinationVC = segue.destination as? ReadingViewController else { return }
        destinationVC.currentBook = ScriptureController.shared.currentBook
        destinationVC.currentChapter = ScriptureController.shared.currentChapter
    }
}
