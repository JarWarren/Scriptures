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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMainView()
        tabThreeTableView.dataSource = self
        tabThreeTableView.delegate = self
        //TODO: datasource needs to be unique for segmentedControlIndex 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabThreeSegmentedControl.sendActions(for: .valueChanged)
        tabBarController?.tabBar.tintColor = #colorLiteral(red: 0.6307423711, green: 0.558336854, blue: 0.09566646069, alpha: 1)
        self.navigationController?.navigationBar.shadowVisibile(true)
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
        case 1: return MemorySetController.shared.allMemorySets.count
        case 0: return EntryController.shared.allEntries.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tabThreeSegmentedControl.selectedSegmentIndex {
        // TODO: case 2 : Put the specific mastery verses into their own array.
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "memoryCell", for: indexPath) as? MemorizeCell else { return UITableViewCell() }
            let memorySet = MemorySetController.shared.allMemorySets[indexPath.row]
            cell.memorySet = memorySet
            return cell
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
            let cellEntry = EntryController.shared.allEntries[indexPath.row]
            cell.textLabel?.text = cellEntry.entryTitle
            if let date = cellEntry.entryDate {
                cell.detailTextLabel?.text = date.mMdDyY
            }
            
            if cellEntry.entryCategory < 10 {
                
                cell.imageView?.image = UIImage(named: "blank")
                if let height = cell.imageView?.heightAnchor,
                    let width = cell.imageView?.widthAnchor {
                    NSLayoutConstraint.activate([
                        height.constraint(equalToConstant: 15),
                        width.constraint(equalToConstant: 15)])
                }
                cell.imageView?.backgroundColor = ColorKey.colorDictionary[cellEntry.entryCategory]
                cell.imageView?.layer.borderWidth = 1
                cell.imageView?.layer.borderColor = UIColor.black.cgColor
                cell.imageView?.layer.cornerRadius = 7
            } else {
                cell.imageView?.image = nil
            }
            return cell
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch tabThreeSegmentedControl.selectedSegmentIndex {
            
        case 1:
            if editingStyle == .delete {
                let dyingSet = MemorySetController.shared.allMemorySets[indexPath.row]
                MemorySetController.shared.deleteSet(memorySet: dyingSet)
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
        
        let barButton = UIBarButtonItem(image: UIImage(named: "newEntryBarButton"), style: .plain, target: self, action: #selector(addEntryButtonTapped))
        barButton.tintColor = #colorLiteral(red: 0.6307423711, green: 0.558336854, blue: 0.09566646069, alpha: 1)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func addEntryButtonTapped(_ sender: UIBarButtonItem) {
        
        let newEntryView = UIStoryboard(name: "TabThree", bundle: nil).instantiateViewController(withIdentifier: "EntryDetailView") as! EntryDetailView
        newEntryView.parentSelectedIndex = 0
        tabThreeSegmentedControl.selectedSegmentIndex = 0
        
        navigationController?.pushViewController(newEntryView, animated: true)
    }
    
    @IBAction func tabThreeSegmentedControlValueChanged(_ sender: Any) {
        tabThreeTableView.reloadData()
        if tabThreeSegmentedControl.selectedSegmentIndex == 1 {
            tabBarController?.viewControllers?[2].tabBarItem.badgeValue = nil
        }
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
            destinationVC.memorySet = MemorySetController.shared.allMemorySets[indexPath.row]
        case 0:
            destinationVC.parentSelectedIndex = 0
            destinationVC.entry = EntryController.shared.allEntries[indexPath.row]
            destinationVC.shouldClose = false
        default: return
        }
    }
}
