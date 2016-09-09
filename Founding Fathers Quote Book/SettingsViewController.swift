//
//  SettingsViewController.swift
//  Founding Fathers Quote Book
//
//  Created by Steve Liddle on 9/8/16.
//  Copyright © 2016 Steve Liddle. All rights reserved.
//

import UIKit

class SettingsViewController : UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    // MARK: - Constants
    
    private struct Component {
        static let Hours = 0
        static let Minutes = 1
        static let AmPm = 2
    }

    private struct Picker {
        static let AmPmCount = 2
        static let AM = "AM"
        static let ComponentWidth: CGFloat = 50.0
        static let InitialHourIndex = 6
        static let MinutesPerGroup = 5
        static let NumberOfHours = 12
        static let NumberOfMinuteElements = 12
        static let PM = "PM"
        static let RowHeight: CGFloat = 30.0
        static let WheelFactor = 24
    }

    private struct Color {
        static let disabled = UIColor.clear
        static let enabled = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
    }

    // MARK: - Outlets
    
    @IBOutlet weak var notificationsSwitch: UISwitch!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet var dayButtons: [UIButton]!

    // MARK: - Properties
    
    var notificationsOn = true
    var hourIndex = Picker.InitialHourIndex
    var minutesIndex = 0
    var isAm = true
    var notifyDays = [ true, true, true, true, true, true, true ]
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }

    // MARK: - Helpers
    
    func updateUI() {
        notificationsSwitch.setOn(notificationsOn, animated: false)

        pickerView.selectRow(hourIndex + Picker.WheelFactor * Picker.NumberOfHours,
                             inComponent: Component.Hours, animated: false)
        pickerView.selectRow(minutesIndex + Picker.WheelFactor * Picker.NumberOfMinuteElements,
                             inComponent: Component.Minutes, animated: false)
        pickerView.selectRow(isAm ? 0 : 1, inComponent: Component.AmPm, animated: false)
        
        for button in dayButtons {
            button.backgroundColor = notifyDays[button.tag] ? Color.enabled : Color.disabled
        }
    }
    
    // MARK: - Actions
    
    @IBAction func toggleNotifications(_ sender: UISwitch) {
        notificationsOn = sender.isOn
    }
    
    @IBAction func toggleDay(_ sender: UIButton) {
        notifyDays[sender.tag] = !notifyDays[sender.tag]
        updateUI()
    }
    
    // MARK: - Picker data source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return Component.AmPm + 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
            case Component.Hours:
                return Picker.NumberOfHours * (Picker.WheelFactor * 2 + 1)
            case Component.Minutes:
                return Picker.NumberOfMinuteElements * (Picker.WheelFactor * 2 + 1)
            case Component.AmPm:
                return Picker.AmPmCount
            default:
                return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case Component.Hours:
            return String(row % Picker.NumberOfHours + 1)
        case Component.Minutes:
            return String(format: "%02d", row % Picker.NumberOfMinuteElements * Picker.MinutesPerGroup)
        case Component.AmPm:
            return row <= 0 ? Picker.AM : Picker.PM
        default:
            return nil
        }
    }
    
    // MARK: - Picker delegate
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component != Component.AmPm {
            let rowCount = component == Component.Hours ? Picker.NumberOfHours : Picker.NumberOfMinuteElements
            if row < Picker.WheelFactor * rowCount || row >= (Picker.WheelFactor + 1) * rowCount {

                pickerView.selectRow(row % rowCount + Picker.WheelFactor * rowCount,
                                     inComponent: component, animated: false)
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return Picker.RowHeight
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return Picker.ComponentWidth
    }
}
