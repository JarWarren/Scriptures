//
//  AllGoalsVC.swift
//  BookOfMormon
//
//  Created by Jared Warren on 12/19/18.
//  Copyright © 2018 Warren. All rights reserved.
//

import UIKit

class AllGoalsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Outlets and Properties
    @IBOutlet weak var allGoalsTableView: UITableView!
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMainView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.popToRootViewController(animated: animated)
    }
    
    func setupMainView() {
        
        title = "All Goals"
        allGoalsTableView.dataSource = self
        allGoalsTableView.delegate = self
    }
    
    // MARK: - TableView DataSource Methods
    // TODO: Goals can be deleted.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GoalController.shared.allGoals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell") else { return UITableViewCell() }
        let goal = GoalController.shared.allGoals[indexPath.row]
        cell.textLabel?.text = goal.name
        if let progress = goal.currentProgress {
            cell.detailTextLabel?.text = TestamentKeys.dictionary[goal.goalTestament]! + "  -  \(progress)% Progress"
        } else {
            cell.detailTextLabel?.text = TestamentKeys.dictionary[goal.goalTestament]! + "  -  0% Progress"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let deadGoal = GoalController.shared.allGoals[indexPath.row]
            let alertController = UIAlertController(title: "Delete \(deadGoal.name)?", message: "This action cannot be undone.", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
                    GoalController.shared.delete(goal: deadGoal)
                    tableView.deleteRows(at: [indexPath], with: .fade)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        if editingStyle == .insert {
            
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
}
