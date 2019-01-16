//
//  NewGoalViewController.swift
//  BookOfMormon
//
//  Created by Jared Warren on 1/8/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import UIKit

class NewGoalViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var goalTypeLabel: UILabel!
    @IBOutlet weak var goalTypeSwitch: UISwitch!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var partialProgressButton: UIButton!
    @IBOutlet weak var chaptersTextField: UITextField!
    @IBOutlet weak var chaptersLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    var startPosition = [0, 0, 0]
    //TODO: Hide the pickerView as soon as they set a custom start position.
    var hasDeadline = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        pickerView.delegate = self
        pickerView.dataSource = self
        chaptersTextField.delegate = self
        nameTextField.delegate = self
        datePicker.locale = Locale(identifier: "en_US")
        self.title = "New Goal"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.shadowVisibile(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.popToRootViewController(animated: animated)
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
        let options = ["Book of Mormon", "Pearl of Great Price", "Doctrine & Covenants", "New Testament", "Old Testament"]
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
        case false:
            guard let dailyChapters = chaptersTextField.text else { return }
            guard let chapters = Int(dailyChapters) else { return }
            GoalController.shared.createIncrementalGoal(name: goalName, startPosition: startPosition, dailyChapters: chapters)
        }
        self.navigationController?.popToRootViewController(animated: true)
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
