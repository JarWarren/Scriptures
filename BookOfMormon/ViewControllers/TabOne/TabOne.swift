//
//  TabOne.swift
//  BookOfMormon
//
//  Created by Jared Warren on 12/15/18.
//  Copyright © 2018 Warren. All rights reserved.
//

import UIKit

class TabOne: UIViewController, UITableViewDelegate, UITableViewDataSource, PrimaryGoalViewDelegate {
    
    // MARK: - Outlets and Properties
    @IBOutlet weak var tabOneSegmentedControl: UISegmentedControl!
    @IBOutlet weak var allGoalsTableView: UITableView!
    var chaptersToRead: Double?
    var subviews = [UIView]()
    var daysLeft: Double?
    
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
        primaryGoalView()
        tabBarController?.tabBar.tintColor = #colorLiteral(red: 0, green: 0.5016700625, blue: 0.005194439087, alpha: 1)
        self.navigationController?.navigationBar.shadowVisibile(true)
        if let title = GoalController.shared.primary?.goal?.name {
            self.title = title
        }
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
    func hideSubviews() {
        
        for view in subviews {
            view.isHidden = true
        }
        subviews.removeAll()
    }
    
    func primaryGoalView() {
        
        guard let primaryGoalView = Bundle.main.loadNibNamed("PrimaryGoal", owner: nil, options: nil)![0] as? PrimaryGoalView else { return }
        tabOneSegmentedControl.selectedSegmentIndex = 0
        primaryGoalView.delegate = self
        self.view.addSubview(primaryGoalView)
        subviews.append(primaryGoalView)
        primaryGoalView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            primaryGoalView.topAnchor.constraint(equalTo: tabOneSegmentedControl.bottomAnchor, constant: 1),
            primaryGoalView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            primaryGoalView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            primaryGoalView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)])
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
    }

    // MARK: Actions
    @IBAction func tabOneSegmentedControlValueChanged(_ sender: Any) {
        
        hideSubviews()
        switch tabOneSegmentedControl.selectedSegmentIndex {
        case 0:
            primaryGoalView()
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
        
        guard let destinationTestament = GoalController.shared.primary?.goal?.testament,
            let destinationBook = GoalController.shared.primary?.goal?.currentBook,
            let destinationChapter = GoalController.shared.primary?.goal?.currentChapter else {
                newGoalButtonTapped(self)
                return
        }
        ScriptureController.shared.selectedTestament = TestamentKeys.selectedTestament[Int(destinationTestament)]
        ScriptureController.shared.change(testament: ScriptureController.shared.selectedTestament ?? TestamentKeys.BoM) { (_) in
            
            let readingViewController = UIStoryboard(name: "Reader", bundle: nil).instantiateViewController(withIdentifier: "ReadingViewController") as! ReadingViewController
            readingViewController.currentBook = Int(destinationBook)
            readingViewController.currentChapter = Int(destinationChapter)
            readingViewController.bookmarkShouldEditGoal = true
            
            self.navigationController?.pushViewController(readingViewController, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? GoalDetailsViewController,
            let indexPath = allGoalsTableView.indexPathForSelectedRow else { return }
        let goal = GoalController.shared.allGoals?[indexPath.row]
        destinationVC.goal = goal
    }
}
