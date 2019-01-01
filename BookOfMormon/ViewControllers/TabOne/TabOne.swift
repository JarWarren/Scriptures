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
    @IBOutlet weak var menuButton1: UIButton!
    @IBOutlet weak var menuButton2: UIButton!
    @IBOutlet weak var menuButton3: UIButton!
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
        todayReadingButton.layer.borderColor = UIColor.black.cgColor
        barButton = navigationItem.rightBarButtonItem
        menuButton1.translatesAutoresizingMaskIntoConstraints = false
        menuButton2.translatesAutoresizingMaskIntoConstraints = false
        menuButton3.translatesAutoresizingMaskIntoConstraints = false
        
        guard let barButton = barButton
            else { return }
        barButton.target = self
        barButton.action = #selector(menuButtonTapped)
        
        let margins = self.view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            menuButton1.bottomAnchor.constraint(equalTo: margins.topAnchor),
            menuButton1.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            menuButton2.bottomAnchor.constraint(equalTo: margins.topAnchor),
            menuButton2.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            menuButton3.bottomAnchor.constraint(equalTo: margins.topAnchor),
            menuButton3.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ])
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
                self.menuButton1.center = CGPoint(x: self.menuButton1.center.x, y: self.menuButton1.center.y + self.menuButton1.frame.height)
                self.menuButton2.center = CGPoint(x: self.menuButton2.center.x, y: self.menuButton2.center.y + self.menuButton2.frame.height * 2)
                self.menuButton3.center = CGPoint(x: self.menuButton3.center.x, y: self.menuButton3.center.y + self.menuButton3.frame.height * 3)
            }, completion: nil)
            self.menuIsOpen = true
        case true:
            dismissMenu()
        }
    }
    
    func dismissMenu() {
        guard menuIsOpen == true else { return }
        self.menuButton1.center.y -= self.menuButton1.frame.height
        self.menuButton2.center.y -= self.menuButton2.frame.height * 2
        self.menuButton3.center.y -= self.menuButton3.frame.height * 3
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
