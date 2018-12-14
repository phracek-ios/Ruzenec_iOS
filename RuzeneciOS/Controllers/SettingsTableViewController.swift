//
//  SettingsTableViewController.swift
//  RuzeneciOS
//
//  Created by Jiri Ostatnicky on 11/07/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var NightSwitchLabel: UILabel!
    @IBOutlet weak var NightSwitch: UISwitch!
    @IBOutlet weak var DimOffSwitch: UISwitch!
    @IBOutlet weak var DimOffScreenLabel: UILabel!

    @IBOutlet weak var NightSwitchCell: UITableViewCell!
    @IBOutlet weak var DimOffSwitchCell: UITableViewCell!
    
    var DarkModeOn = Bool()
    
    override func viewDidLoad() {
        let userDefaults = UserDefaults.standard
        title = "Nastavení Růžence"
        NightSwitch.isOn = userDefaults.bool(forKey: "NightSwitch")
        if NightSwitch.isOn == true {
            enabledDark()
        }
        else {
            disabledDark()
        }
        DimOffSwitch.isOn = userDefaults.bool(forKey: "DimmScreen")
        self.tableView.tableFooterView = UIView()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }
    
    @IBAction func DimOffAction(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        if DimOffSwitch.isOn == true {
            UIApplication.shared.isIdleTimerDisabled = true
            userDefaults.set(true, forKey: "DimmScreen")
        }
        else {
            UIApplication.shared.isIdleTimerDisabled = false
            userDefaults.set(false, forKey: "DimmScreen")
        }
    }
    
    @IBAction func NightSwitchAction(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        if NightSwitch.isOn == true {
            userDefaults.set(true, forKey: "NightSwitch")
            enabledDark()
            NotificationCenter.default.post(name: .darkModeEnabled, object:nil)
        }
        else {
            userDefaults.set(false, forKey: "NightSwitch")
            disabledDark()
            NotificationCenter.default.post(name: .darkModeDisabled, object: nil)
        }
    }

    
    func enabledDark() {
        self.view.backgroundColor = KKCBackgroundNightMode
        self.NightSwitchLabel.textColor = KKCTextNightMode
        self.NightSwitchLabel.backgroundColor = KKCBackgroundNightMode
        self.NightSwitchCell.backgroundColor = KKCBackgroundNightMode
        self.DimOffScreenLabel.textColor = KKCTextNightMode
        self.DimOffSwitch.backgroundColor = KKCBackgroundNightMode
        self.DimOffSwitchCell.backgroundColor = KKCBackgroundNightMode
    }
    
    func disabledDark() {
        self.view.backgroundColor = KKCBackgroundLightMode
        self.NightSwitchLabel.textColor = KKCTextLightMode
        self.NightSwitchLabel.backgroundColor = KKCBackgroundLightMode
        self.NightSwitchCell.backgroundColor = KKCBackgroundLightMode
        self.DimOffScreenLabel.textColor = KKCTextLightMode
        self.DimOffSwitch.backgroundColor = KKCBackgroundLightMode
        self.DimOffSwitchCell.backgroundColor = KKCBackgroundLightMode
    }
}
