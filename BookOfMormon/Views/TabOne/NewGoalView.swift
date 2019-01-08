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
    @IBOutlet weak var saveButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    func setupView() {
        
        saveButton.layer.cornerRadius = saveButton.frame.height / 2
        saveButton.layer.borderColor = UIColor.lightGray.cgColor
        saveButton.layer.borderWidth = 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return 0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 0
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func goalTypeSwitchValueChanged(_ sender: Any) {
        
    }
    
}
