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
        case 1:
            guard let verseCount = VerseController.shared.memorizingVerses?.count else { return 1 }
            if verseCount > 0 {
                return verseCount
            } else {
                return 1
            }
        case 0: return EntryController.shared.allEntries.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tabThreeSegmentedControl.selectedSegmentIndex {
        // TODO: case 2 : Put the specific mastery verses into their own array.
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "memoryCell", for: indexPath) as? MemorizeCell else { return UITableViewCell() }
            guard VerseController.shared.memorizingVerses?.count != 0 else {
                cell.isUserInteractionEnabled = false
                return cell
            }
            let verseSet = VerseController.shared.memorizingVerses?[indexPath.row]
            cell.memorizedVerseSet = verseSet
            return cell
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
            let cellEntry = EntryController.shared.allEntries[indexPath.row]
            cell.textLabel?.text = cellEntry.entryTitle
            if let date = cellEntry.entryDate {
                cell.detailTextLabel?.text = date.mMdDyY
            }
            return cell
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch tabThreeSegmentedControl.selectedSegmentIndex {
            
        case 1:
            if editingStyle == .delete {
                guard let deletedMemorization = VerseController.shared.memorizingVerses?[indexPath.row] else { return }
                VerseController.shared.deleteMemorizedVerses(verses: deletedMemorization)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case 0:
            if editingStyle == .delete {
                let deletedEntry = EntryController.shared.allEntries[indexPath.row]
                EntryController.shared.deleteEntry(entry: deletedEntry)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        default: return
        }
    }
    
    func setupMainView() {
        
        addEntryButton?.title = "New Entry"
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
            destinationVC.verses = VerseController.shared.memorizingVerses?[indexPath.row]
        case 0:
            destinationVC.parentSelectedIndex = 0
            destinationVC.entry = EntryController.shared.allEntries[indexPath.row]
            destinationVC.shouldClose = false
        default: return
        }
        
    }
}
