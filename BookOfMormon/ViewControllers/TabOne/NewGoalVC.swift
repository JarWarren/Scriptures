//
//  NewGoalVC.swift
//  BookOfMormon
//
//  Created by Jared Warren on 12/19/18.
//  Copyright © 2018 Warren. All rights reserved.
//

import UIKit

class NewGoalViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    // MARK: - Outlets and Properties
    @IBOutlet weak var newGoalTextField: UITextField!
    @IBOutlet weak var newGoalSegmentedControl: UISegmentedControl!
    @IBOutlet weak var newGoalPickerView: UIPickerView!
    @IBOutlet weak var newGoalDatePicker: UIDatePicker!
    @IBOutlet weak var newGoalCreateButton: UIButton!
    @IBOutlet weak var instructionsLabel: UILabel!
    
    // MARK: - LifeCyle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMainView()
        setupPickerViews()
        self.newGoalTextField.delegate = self
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
            let testament = newGoalPickerView.selectedRow(inComponent: 0)
//                        GoalController.shared.createGoal(name: goalName, endDate: deadline, startDate: Date(), testament: testament)
            
        default:
            guard let goalName = newGoalTextField.text, goalName.isEmpty == false else { return }
            let chapters = newGoalPickerView.selectedRow(inComponent: 1)
            let testament = newGoalPickerView.selectedRow(inComponent: 0)
//            GoalController.shared.createGoal(name: goalName, endDate: nil, startDate: Date(), chapters: chapters, testament: testament)
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func newGoalSegmentedControlValueChanged(_ sender: Any) {
        
        switch newGoalSegmentedControl.selectedSegmentIndex {
        case 0:
            newGoalDatePicker.isHidden = false
            instructionsLabel.text = "When do you want to finish by?"
        default:
            newGoalDatePicker.isHidden = true
            instructionsLabel.text = "Select which testament and the number of chapters per day."
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
        
    }
    
    
    // MARK: - Setup
    func setupMainView() {
        
        title = "New Goal"
        newGoalCreateButton.layer.cornerRadius = newGoalCreateButton.layer.frame.height/2
    }
    
    // MARK: - PickerView
    func setupPickerViews() {
        
        self.newGoalPickerView.dataSource = self
        self.newGoalPickerView.delegate = self
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let options = ["BoM", "PoGP", "D&C", "NT", "OT"]
        switch component {
        case 0:
            return options[row]
        default:
            return "\(row + 1)"
            
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch newGoalDatePicker.isHidden {
        case true:
            return 2
        case false:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 5
        default:
            return 10
        }
    }
}
