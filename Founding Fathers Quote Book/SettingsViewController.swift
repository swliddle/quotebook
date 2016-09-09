//
//  SettingsViewController.swift
//  Founding Fathers Quote Book
//
//  Created by Steve Liddle on 9/8/16.
//  Copyright © 2016 Steve Liddle. All rights reserved.
//

import UIKit

class SettingsViewController : UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
            case 0:
                return 12
            case 1:
                return 12
            case 2:
                return 2
            default:
                return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return String(row + 1)
        case 1:
            return String(row * 5)
        case 2:
            return row <= 0 ? "AM" : "PM"
        default:
            return nil
        }
    }
}
