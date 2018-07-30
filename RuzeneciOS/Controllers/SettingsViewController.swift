//
//  SettingsViewController.swift
//  RuzeneciOS
//
//  Created by Jiri Ostatnicky on 11/07/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var NightSwitch: UISwitch!
    @IBOutlet weak var NightSwitchLabel: UILabel!
    @IBOutlet weak var DimOffSwitch: UISwitch!
    @IBOutlet weak var DimOffScreenLabel: UILabel!
    @IBOutlet weak var FullScreenLabel: UILabel!
    @IBOutlet weak var FullScreenSwitch: UISwitch!
    
    var DarkModeOn = Bool()
    
    override func viewDidLoad() {
        let userDefaults = UserDefaults.standard
        NightSwitch.isOn = userDefaults.bool(forKey: "NightSwitch")
        if NightSwitch.isOn == true {
            enabledDark()
        }
        else {
            disabledDark()
        }
        DimOffSwitch.isOn = userDefaults.bool(forKey: "DimmScreen")
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
        }
        else {
            userDefaults.set(false, forKey: "NightSwitch")
            disabledDark()
        }
    }
    @IBAction func FullScreenAction(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        if FullScreenSwitch.isOn == true {
            userDefaults.set(true, forKey: "FullScreen")
            
        }
        else {
            userDefaults.set(false, forKey: "FullScreen")
        }

    }
    func enabledDark() {
        self.view.backgroundColor = UIColor.black
        self.NightSwitchLabel.textColor = UIColor.white
        self.DimOffScreenLabel.textColor = UIColor.white
        self.FullScreenLabel.textColor = UIColor.white
    }
    
    func disabledDark() {
        self.view.backgroundColor = UIColor.white
        self.NightSwitchLabel.textColor = UIColor.black
        self.DimOffScreenLabel.textColor = UIColor.black
        self.FullScreenLabel.textColor = UIColor.black
    }
}
