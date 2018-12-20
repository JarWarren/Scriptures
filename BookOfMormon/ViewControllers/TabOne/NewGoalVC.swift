//
//  NewGoalVC.swift
//  BookOfMormon
//
//  Created by Jared Warren on 12/19/18.
//  Copyright © 2018 Warren. All rights reserved.
//

import UIKit

class NewGoalViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Outlets and Properties
    @IBOutlet weak var newGoalTextField: UITextField!
    @IBOutlet weak var newGoalSegmentedControl: UISegmentedControl!
    @IBOutlet weak var newGoalPickerView: UIPickerView!
    @IBOutlet weak var newGoalDatePicker: UIDatePicker!
    @IBOutlet weak var newGoalCreateButton: UIButton!
    
    // MARK: - LifeCyle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMainView()
        setupPickerView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.popToRootViewController(animated: animated)
    }
    
    // MARK: - Actions
    @IBAction func createNewGoalButtonTapped(_ sender: UIButton) {
        
        // TODO: Ensure the selected date is in the future.
        switch newGoalSegmentedControl.selectedSegmentIndex {
            
        case 0:
            guard let goalName = newGoalTextField.text, goalName.isEmpty == false else { return }
            let deadline = newGoalDatePicker.date
            GoalController.shared.createGoal(name: goalName, endDate: deadline)
            
        default:
            guard let goalName = newGoalTextField.text, goalName.isEmpty == false else { return }
            
            switch newGoalPickerView.selectedRow(inComponent: 0) {
                
            case 0:
                let dailyChapters = newGoalPickerView.selectedRow(inComponent: 1) + 1
                GoalController.shared.createGoal(name: goalName, endDate: nil, verses: nil, chapters: dailyChapters, pages: nil)
            default:
                let dailyPages = newGoalPickerView.selectedRow(inComponent: 1) + 1
                GoalController.shared.createGoal(name: goalName, endDate: nil, verses: nil, chapters: nil, pages: dailyPages)
            }
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func newGoalSegmentedControlValueChanged(_ sender: Any) {
        
        switch newGoalSegmentedControl.selectedSegmentIndex {
        case 0:
            newGoalDatePicker.isHidden = false
            newGoalPickerView.isHidden = true
        default:
            newGoalDatePicker.isHidden = true
            newGoalPickerView.isHidden = false
        }
    }
    
    // MARK: - Setup
    
    func setupMainView() {
    
        title = "New Goal"
        newGoalCreateButton.layer.cornerRadius = newGoalCreateButton.layer.frame.height/2
    }
    
    // MARK: - PickerView
    func setupPickerView() {
        
        self.newGoalPickerView.isHidden = true
        self.newGoalPickerView.dataSource = self
        self.newGoalPickerView.delegate = self
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let options = ["Chapters", "Pages"]
        switch component {
        case 0:
            return options[row]
        default:
            return "\(row + 1)"
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 2
        default:
            return 20
        }
    }
}
