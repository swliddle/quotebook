//
//  SettingsViewController.swift
//  Founding Fathers Quote Book
//
//  Created by Steve Liddle on 9/14/17.
//  Copyright © 2017 Steve Liddle. All rights reserved.
//

import UIKit

class SettingsViewController : UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Constants
    
    private struct Color {
        static let disabled = UIColor.clear
        static let enabled = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
    }
    
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
        static let NoonIndex = 11
        static let NumberOfHours = 12
        static let NumberOfMinutes = 60
        static let PM = "PM"
        static let RowHeight: CGFloat = 30.0
    }
    
    private enum Settings: String {
        case notificationsOn, hourIndex, minutesIndex, isAm, notifyDays
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
    
        restoreSettings()
        updateUI()
    }
    
    // MARK: - Helpers
    
    private func restoreSettings() {
        let defaults = UserDefaults.standard
        
        if let days = defaults.array(forKey: Settings.notifyDays.rawValue) as? [Bool] {
            notifyDays = days
            notificationsOn = defaults.bool(forKey: Settings.notificationsOn.rawValue)
            hourIndex = defaults.integer(forKey: Settings.hourIndex.rawValue)
            minutesIndex = defaults.integer(forKey: Settings.minutesIndex.rawValue)
            isAm = defaults.bool(forKey: Settings.isAm.rawValue)
        }
    }

    private func saveSettings() {
        let defaults = UserDefaults.standard
        
        defaults.set(notificationsOn, forKey: Settings.notificationsOn.rawValue)
        defaults.set(hourIndex, forKey: Settings.hourIndex.rawValue)
        defaults.set(minutesIndex, forKey: Settings.minutesIndex.rawValue)
        defaults.set(isAm, forKey: Settings.isAm.rawValue)
        defaults.set(notifyDays, forKey: Settings.notifyDays.rawValue)
        
        defaults.synchronize()
    }

    private func updateUI() {
        notificationsSwitch.setOn(notificationsOn, animated: false)

        pickerView.selectRow(hourIndex, inComponent: Component.Hours, animated: false)
        pickerView.selectRow(minutesIndex, inComponent: Component.Minutes, animated: false)
        pickerView.selectRow(isAm ? 0 : 1, inComponent: Component.AmPm, animated: false)

        for button in dayButtons {
            button.backgroundColor = notifyDays[button.tag] ? Color.enabled : Color.disabled
        }
    }
    
    // MARK: - Actions
    
    @IBAction func toggleNotifications(_ sender: UISwitch) {
        notificationsOn = sender.isOn
        saveSettings()
    }
    
    @IBAction func toggleDay(_ sender: UIButton) {
        notifyDays[sender.tag] = !notifyDays[sender.tag]
        updateUI()
        saveSettings()
    }
    
    // MARK: - Picker data source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return Component.AmPm + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case Component.Hours:
            return Picker.NumberOfHours
        case Component.Minutes:
            return Picker.NumberOfMinutes
        case Component.AmPm:
            return Picker.AmPmCount
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case Component.Hours:
            return "\(row + 1)"
        case Component.Minutes:
            return String(format: "%02d", row)
        case Component.AmPm:
            return row <= 0 ? Picker.AM : Picker.PM
        default:
            return nil
        }
    }
    
    // MARK: - Picker delegate
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case Component.Hours:
            hourIndex = row
        case Component.Minutes:
            minutesIndex = row
        case Component.AmPm:
            isAm = row <= 0 ? true : false
        default:
            break
        }
        
        saveSettings()
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return Picker.RowHeight
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return Picker.ComponentWidth
    }
}
