//
//  TabThree.swift
//  BookOfMormon
//
//  Created by Jared Warren on 12/18/18.
//  Copyright © 2018 Warren. All rights reserved.
//

import UIKit

class TabThree: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    @IBOutlet weak var tabThreeTableView: UITableView!
    @IBOutlet weak var tabThreeSegmentedControl: UISegmentedControl!
    var addEntryButton: UIBarButtonItem? {
        return self.navigationItem.rightBarButtonItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMainView()
        tabThreeTableView.dataSource = self
        tabThreeTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabThreeTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        switch tabThreeSegmentedControl.selectedSegmentIndex {
        case 2: return 4
        default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tabThreeSegmentedControl.selectedSegmentIndex {
        case 2: return 25
        case 1: return VerseController.shared.memorizingVerses.count
        case 0: return EntryController.shared.allEntries.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studyCell", for: indexPath)
        
        switch tabThreeSegmentedControl.selectedSegmentIndex {
        // TODO: case 2 : Put the specific mastery verses into their own array.
        case 1:
            let cellVerse = VerseController.shared.memorizingVerses[indexPath.row]
            cell.textLabel?.text = cellVerse.reference
            cell.detailTextLabel?.text = nil
        // TODO: Custom cell that remembers if the verse was memorized. Allows for deletion. ☑️
        case 0:
            let cellEntry = EntryController.shared.allEntries[indexPath.row]
            cell.textLabel?.text = cellEntry.entryTitle
            if let date = cellEntry.entryDate {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            let time = dateFormatter.string(from: date)
            cell.detailTextLabel?.text = time
            }
        default: return cell
        }
        
        return cell
    }
    
    func setupMainView() {
        
        addEntryButton?.title = "New"
        addEntryButton?.target = self
        addEntryButton?.action = #selector(addEntryButtonTapped)
    }
    
    @objc func addEntryButtonTapped(_ sender: UIBarButtonItem) {
        
        let newEntryView = UIStoryboard(name: "TabThree", bundle: nil).instantiateViewController(withIdentifier: "EntryDetailView") as! EntryDetailView
        newEntryView.parentSelectedIndex = 0
        
        navigationController?.pushViewController(newEntryView, animated: true)
    }
    
    @IBAction func tabThreeSegmentedControlValueChanged(_ sender: Any) {
        tabThreeTableView.reloadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? EntryDetailView,
        let indexPath = tabThreeTableView.indexPathForSelectedRow else { return }
        
        switch tabThreeSegmentedControl.selectedSegmentIndex {
        case 2:
            destinationVC.parentSelectedIndex = 2
        case 1:
            destinationVC.parentSelectedIndex = 1
            destinationVC.titleText = VerseController.shared.memorizingVerses[indexPath.row].reference
            destinationVC.bodyText = VerseController.shared.memorizingVerses[indexPath.row].text
            destinationVC.isMemorized = VerseController.shared.memorizingVerses[indexPath.row].memorized
        case 0:
            destinationVC.parentSelectedIndex = 0
            destinationVC.titleText = EntryController.shared.allEntries[indexPath.row].entryTitle
            destinationVC.bodyText = EntryController.shared.allEntries[indexPath.row].entryText
            destinationVC.date = EntryController.shared.allEntries[indexPath.row].entryDate
        default: return
        }
        
    }
}
