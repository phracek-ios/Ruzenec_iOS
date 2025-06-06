//
//  SettingsTimeTableViewCell.swift
//  RuzeneciOS
//
//  Created by Petr Hracek on 28.05.2025.
//  Copyright © 2025 Petr Hracek. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

class SettingsTimeTableViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {

    static let cellId = "settingsTimeItem"
    let keys = SettingsBundleHelper.SettingsBundleKeys.self
    lazy var title : UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 18)
        l.backgroundColor = .clear
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    lazy var detail : UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14)
        l.backgroundColor = .clear
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    lazy var timePicker: UIPickerView = {
       let dp = UIPickerView()
        dp.translatesAutoresizingMaskIntoConstraints = false
        //dp.addTarget(self, action: #selector(self.getReminderTime(_ :)), for: .valueChanged)
        return dp
    }()
    
    lazy var enableSwitch: UISwitch = {
        let s = UISwitch()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.addTarget(self, action: #selector(self.enableReminder(_:)), for: .valueChanged)
        return s
    }()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var stackViewInfo: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    var backColor = KKCBackgroundLightMode
    var labelColor = KKCTextLightMode
    var settingsItem : SettingsItem?
    let userDefaults = UserDefaults.standard
    var hour: Int = 18
    var minute: Int = 0
    var pickerData: [[String]] = [[String]]()
    var pickerDataHours: [String] = []
    var pickerDataMinutes: [String] = []

    func configureCell(settingsItem: SettingsItem, cellWidth: CGFloat) {
        self.settingsItem = settingsItem
        self.timePicker.delegate = self
        self.timePicker.dataSource = self
        for h in 0...23 {
            pickerDataHours.append(String(format: "%02d", h))
        }
        for m in 0...59 {
            pickerDataMinutes.append(String(format: "%02d", m))
        }
        pickerData = [pickerDataHours, pickerDataMinutes]
        let darkMode = userDefaults.bool(forKey: keys.night)
        if darkMode {
            self.labelColor = KKCTextNightMode
            self.backColor = KKCBackgroundNightMode
        }
        else {
            self.labelColor = KKCTextLightMode
            self.backColor = KKCBackgroundLightMode
        }
        
        contentView.addSubview(stackView)
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: stackView)
        contentView.addConstraintsWithFormat(format: "V:|[v0]|", views: stackView)
        
        stackView.addSubview(stackViewInfo)
        stackViewInfo.addSubview(title)
        stackViewInfo.addSubview(enableSwitch)
        stackView.addSubview(timePicker)

        stackView.addConstraintsWithFormat(format: "H:|[v0]|", views: stackViewInfo)
        stackView.addConstraintsWithFormat(format: "H:[v0(150)]-20-|", views: timePicker)
        stackViewInfo.addConstraintsWithFormat(format: "H:|-20-[v0]", views: title)
        stackViewInfo.addConstraintsWithFormat(format: "H:[v0]-20-|", views: enableSwitch)
        stackViewInfo.addConstraintsWithFormat(format: "V:|-10-[v0]", views: title)
        stackViewInfo.addConstraintsWithFormat(format: "V:|-10-[v0]", views: enableSwitch)
        stackView.addConstraintsWithFormat(format: "V:|-10-[v0]-10-[v1(100)]-10-|", views: stackViewInfo, timePicker)
        
        title.text = settingsItem.title
        title.textColor = self.labelColor
        enableSwitch.backgroundColor = self.backColor
        enableSwitch.tintColor = self.labelColor
        self.backgroundColor = self.backColor
        if userDefaults.object(forKey: keys.reminderMinute) != nil && userDefaults.object(forKey: keys.reminderHour) != nil {
            minute = userDefaults.integer(forKey: keys.reminderMinute)
            hour = userDefaults.integer(forKey: keys.reminderHour)
        }

        let str_hour = String(format: "%02d", hour)
        let str_minute = String(format: "%02d", minute)
        timePicker.selectRow(pickerDataHours.firstIndex{$0 == str_hour}!, inComponent: 0, animated: true)
        timePicker.selectRow(pickerDataMinutes.firstIndex{$0 == str_minute}!, inComponent: 1, animated: true)
        timePicker.backgroundColor = self.backColor
        if userDefaults.bool(forKey: keys.reminderEnabled) == true {
            enableSwitch.isOn = true
            timePicker.isUserInteractionEnabled = true
        } else {
            enableSwitch.isOn = false
            timePicker.isUserInteractionEnabled = false
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributeString = NSAttributedString(string: self.pickerData[component][row],
                                                 attributes: [NSAttributedString.Key.foregroundColor : self.labelColor])
        return attributeString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let userDefaults = UserDefaults.standard
        let hour = pickerData[0][pickerView.selectedRow(inComponent: 0)]
        let minute = pickerData[1][pickerView.selectedRow(inComponent: 1)]
        userDefaults.set(hour, forKey: keys.reminderHour)
        userDefaults.set(minute, forKey: keys.reminderMinute)
        debugPrint("picked hour: \(hour), picked minute: \(minute)")
        NotificationManager.updateRuzenec()

    }
    
    @objc func enableReminder(_ sender: UISwitch!) {
        print("DesatekCounter: Target \(sender.isOn)")
        if sender.isOn {
            timePicker.isUserInteractionEnabled = true
            userDefaults.set(true, forKey: keys.reminderEnabled)
            NotificationManager.updateRuzenec()
        } else {
            timePicker.isUserInteractionEnabled = false
            userDefaults.set(false, forKey: keys.reminderEnabled)
            NotificationManager.removeNotifications()
        }
    }
    
//    @objc func getReminderTime(_ sender: UIDatePicker!) {
//        let components = Calendar.current.dateComponents([.hour, .minute], from: sender.date)
//        userDefaults.set(components.hour, forKey: keys.reminderHour)
//        userDefaults.set(components.minute, forKey: keys.reminderMinute)
//    }
}
