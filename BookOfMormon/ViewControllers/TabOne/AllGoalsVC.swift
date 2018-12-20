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
            cell.detailTextLabel?.text = "\(progress)"
        } else {
            cell.detailTextLabel?.text = "0% Progress"
        }
        return cell
    }
}
