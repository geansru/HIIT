//
//  PreferencesTableViewController.swift
//  HIIT
//
//  Created by Dmitry Roytman on 02.06.16.
//  Copyright © 2016 Dmitry Roytman. All rights reserved.
//

import UIKit

class PreferencesTableViewController: UITableViewController {
    var currentPhase = PreferencesManager.shared.choosenPhase {
        didSet {
            PreferencesManager.shared.choosenPhase = currentPhase
            currentLevelLabel.text = currentPhase.name
        }
    }
    var picker: UIPickerView!
    // MARK: IBOutlet's
    @IBOutlet weak var levelsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var trainingTimeTextField: UITextField!
    @IBOutlet weak var recoveryTimeTextField: UITextField!
    @IBOutlet weak var numberOfSetsTextField: UITextField!
    @IBOutlet weak var shakeGestureOnSlider: UISwitch!
    @IBOutlet weak var levelsSlider: UISlider!
    @IBOutlet weak var currentLevelLabel: UILabel!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        picker = {
            let picker = UIPickerView(frame: CGRectZero)
            picker.dataSource = self
            picker.delegate = self
            picker.showsSelectionIndicator = true
            return picker
        }()
        [trainingTimeTextField, recoveryTimeTextField, numberOfSetsTextField].forEach {
            $0.inputView = picker }
        updateTextFieldsWithPhase(currentPhase)
        let phaseRawValue = currentPhase.rawValue
        levelsSlider.value = Float(phaseRawValue)
        levelsSegmentedControl.selectedSegmentIndex = phaseRawValue
        currentLevelLabel.text = currentPhase.name
        shakeGestureOnSlider.on = PreferencesManager.shared.isShakeGestureAllow
    }
}

extension PreferencesTableViewController {
    // MARK: IBAction's
    @IBAction func onLevelChange(sender: UISegmentedControl) {
        updateTextFieldsWithPhase(Phase(rawValue: sender.selectedSegmentIndex) ?? Phase.Custom)
    }
    
    @IBAction func onLevelSelect(sender: UISlider) {
        let sliderValue = Int(round(sender.value))
        levelsSegmentedControl.selectedSegmentIndex = sliderValue
        currentPhase = Phase(rawValue: sliderValue) ?? Phase.Custom
    }
    
    @IBAction func onChangeGestureSlider(sender: UISwitch) {
        PreferencesManager.shared.isShakeGestureAllow = sender.on
    }
    
    private func updateTextFieldsWithPhase(phase: Phase) {
        let cycle = phase.cycleFabric
        trainingTimeTextField.text = String(format: "%.2d:%.2d", cycle.actionTime/60, cycle.actionTime%60)
        recoveryTimeTextField.text = String(format: "%.2d:%.2d", cycle.relaxTime/60, cycle.relaxTime%60)
        numberOfSetsTextField.text = String(format: "%.2d", phase.cyclesQuantity)
        [trainingTimeTextField, recoveryTimeTextField, numberOfSetsTextField].forEach {$0.enabled = phase == .Custom}
    }
}

extension PreferencesTableViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        let cycle = currentPhase.cycleFabric
        switch textField {
        case trainingTimeTextField:
            picker.selectRow(cycle.actionTime/60, inComponent: 0, animated: true)
            picker.selectRow(cycle.actionTime%60, inComponent: 1, animated: true)
        case recoveryTimeTextField:
            picker.selectRow(cycle.relaxTime/60, inComponent: 0, animated: true)
//            picker.selectRow(cycle.relaxTime%60, inComponent: 1, animated: true)
        case numberOfSetsTextField:
            let row = currentPhase.cyclesQuantity-1 < 0 ? 0 : currentPhase.cyclesQuantity-1
            picker.selectRow(row, inComponent: 0, animated: true)
        default: break
        }
        
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension PreferencesTableViewController: UIPickerViewDataSource, UIPickerViewDelegate  {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if trainingTimeTextField.isFirstResponder() || recoveryTimeTextField.isFirstResponder() {
            return 2
        }
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if trainingTimeTextField.isFirstResponder() || recoveryTimeTextField.isFirstResponder() {
            return 60
        }
        return 99
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return numberOfSetsTextField.isFirstResponder() ? "\(row+1)" : "\(row)"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if trainingTimeTextField.isFirstResponder() {
            if component == 0 {
                PreferencesManager.shared.customPhaseActionTime = row*60 + picker.selectedRowInComponent(1)
            } else {
                PreferencesManager.shared.customPhaseActionTime = picker.selectedRowInComponent(0)*60 + row
            }
            
        }
        if recoveryTimeTextField.isFirstResponder() {
            if component == 0 {
                PreferencesManager.shared.customPhaseRecoveryTime = row*60 + picker.selectedRowInComponent(1)
            } else {
                PreferencesManager.shared.customPhaseRecoveryTime = picker.selectedRowInComponent(0)*60 + row
            }
        }
        if numberOfSetsTextField.isFirstResponder() {
            PreferencesManager.shared.customPhaseCyclesQuantity = row+1
        }
        updateTextFieldsWithPhase(currentPhase)
    }
}