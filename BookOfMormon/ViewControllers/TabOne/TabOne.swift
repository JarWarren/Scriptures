//
//  TabOne.swift
//  BookOfMormon
//
//  Created by Jared Warren on 12/15/18.
//  Copyright © 2018 Warren. All rights reserved.
//

import UIKit

class TabOne: UIViewController, UITableViewDelegate, UITableViewDataSource, CurrentGoalViewDelegate {
    
    // MARK: - Outlets and Properties
    @IBOutlet weak var tabOneSegmentedControl: UISegmentedControl!
    @IBOutlet weak var allGoalsTableView: UITableView!
    var chaptersToRead = 0
    var subviews = [UIView]()
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtons()
        allGoalsTableView.dataSource = self
        allGoalsTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        allGoalsTableView.reloadData()
        tabOneSegmentedControl.sendActions(for: .valueChanged)
        setupGoal()
        currentGoalView()
        tabBarController?.tabBar.tintColor = #colorLiteral(red: 0, green: 0.5016700625, blue: 0.005194439087, alpha: 1)
        self.navigationController?.navigationBar.shadowVisibile(false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabOneSegmentedControl.selectedSegmentIndex = 0
    }
    
    // MARK: - Setup Methods
    func setupButtons() {
        
        let barButton = UIBarButtonItem(image: UIImage(named: "newGoalBarButton"), style: .plain, target: self, action: #selector(newGoalButtonTapped))
        barButton.tintColor = #colorLiteral(red: 0, green: 0.5016700625, blue: 0.005194439087, alpha: 1)
        self.navigationItem.rightBarButtonItem = barButton
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
        
        /*
        guard let newGoalView = Bundle.main.loadNibNamed("NewGoal", owner: nil, options: nil)![0] as? NewGoalView else { return }
        self.view.addSubview(newGoalView)
        newGoalView.delegate = self
        subviews.append(newGoalView)
        newGoalView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newGoalView.topAnchor.constraint(equalTo: tabOneSegmentedControl.bottomAnchor, constant: 1),
            newGoalView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            newGoalView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            newGoalView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)])
         */
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return GoalController.shared.allGoals?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell", for: indexPath) as? GoalCell else { return UITableViewCell() }
        let goal = GoalController.shared.allGoals?[indexPath.row]
        cell.goal = goal
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            guard let deadGoal = GoalController.shared.allGoals?[indexPath.row],
                let goalName = GoalController.shared.allGoals?[indexPath.row].name else { return }
            let alertController = UIAlertController(title: "Delete \(goalName)?", message: "This action cannot be undone", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
                GoalController.shared.delete(goal: deadGoal)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    // MARK: Actions
    @IBAction func tabOneSegmentedControlValueChanged(_ sender: Any) {
        
        hideSubviews()
        switch tabOneSegmentedControl.selectedSegmentIndex {
        case 0:
            currentGoalView()
        default: return
        }
    }
    
    
    @IBAction func newGoalButtonTapped(_ sender: Any) {
        
        guard let newGoalView = UIStoryboard(name: "NewGoal", bundle: nil).instantiateViewController(withIdentifier: "NewGoal") as? NewGoalViewController else { return }
        newGoalView.hasDeadline = false
        self.navigationController?.pushViewController(newGoalView, animated: true)
    }
    
    // MARK: - Navigation
    func segueToReader() {
        
        guard let destinationTestament = GoalController.shared.primaryGoal?.testament,
            let destinationBook = GoalController.shared.primaryGoal?.currentBook,
            let destinationChapter = GoalController.shared.primaryGoal?.currentChapter else {
                newGoalButtonTapped(self)
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
