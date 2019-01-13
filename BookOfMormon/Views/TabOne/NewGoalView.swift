//
//  NewGoalView.swift
//  BookOfMormon
//
//  Created by Jared Warren on 1/8/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import UIKit

class NewGoalView: UIView, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
   
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var goalTypeLabel: UILabel!
    @IBOutlet weak var goalTypeSwitch: UISwitch!
    @IBOutlet weak var partialProgressButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var chaptersTextField: UITextField!
    @IBOutlet weak var chaptersLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    var startPosition = [0, 0, 0]
    //TODO: Hide the pickerView as soon as they set a custom start position.
    var hasDeadline = true
    var delegate: NewGoalViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
        pickerView.delegate = self
        pickerView.dataSource = self
        chaptersTextField.delegate = self
        nameTextField.delegate = self
        datePicker.locale = Locale(identifier: "en_US")
    }
    
    func setupView() {
        
        saveButton.layer.cornerRadius = saveButton.frame.height / 2
        goalTypeSwitch.isOn = false
        goalTypeSwitch.sendActions(for: .valueChanged)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let options = ["BoM", "PoGP", "D&C", "NT", "OT"]
        return options[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.startPosition[0] = row
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let goalName = nameTextField.text, nameTextField.text?.isEmpty == false else { return }
        switch hasDeadline {
        case true:
            let endDate = datePicker.date
            GoalController.shared.createDeadlineGoal(name: goalName, endDate: endDate, startingPoint: startPosition)
            delegate?.allGoalsView()
        case false:
            guard let dailyChapters = chaptersTextField.text else { return }
            guard let chapters = Int(dailyChapters) else { return }
            GoalController.shared.createIncrementalGoal(name: goalName, startPosition: startPosition, dailyChapters: chapters)
            delegate?.allGoalsView()
        }
    }
    
    @IBAction func goalTypeSwitchValueChanged(_ sender: Any) {
        
        switch hasDeadline {
        case false:
            goalTypeLabel.text = "Deadline"
            datePicker.isHidden = false
            chaptersLabel.isHidden = true
            chaptersTextField.isHidden = true
        case true:
            goalTypeLabel.text = "Daily"
            datePicker.isHidden = true
            chaptersLabel.isHidden = false
            chaptersTextField.isHidden = false
        }
        hasDeadline.toggle()
    }
}

protocol NewGoalViewDelegate: class {
    
    func allGoalsView()
}
