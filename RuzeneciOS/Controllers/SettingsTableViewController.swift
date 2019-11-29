//
//  SettingsTableViewController.swift
//  RuzeneciOS
//
//  Created by Jiri Ostatnicky on 11/07/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit
import BonMot

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var NightSwitchLabel: UILabel!
    @IBOutlet weak var NightSwitch: UISwitch!
    @IBOutlet weak var DimOffSwitch: UISwitch!
    @IBOutlet weak var DimOffScreenLabel: UILabel!

    @IBOutlet weak var NightSwitchCell: UITableViewCell!
    @IBOutlet weak var DimOffSwitchCell: UITableViewCell!
    @IBOutlet weak var VibrateSwitch: UISwitch!
    @IBOutlet weak var VibrateLabel: UILabel!
    @IBOutlet weak var VibrateCell: UITableViewCell!
    
    @IBOutlet weak var footLabel: UILabel!
    @IBOutlet weak var footSwitch: UISwitch!
    @IBOutlet weak var footCell: UITableViewCell!
    
    @IBOutlet weak var fontPickerLabel: UILabel!
    @IBOutlet weak var labelExample: UILabel!
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var fontCell: UITableViewCell!
    
    var DarkModeOn = Bool()
    let exampleText: String = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Etiam neque"
    var fontName: String = ""
    var fontSize: String = "16"
    var back = KKCBackgroundNightMode
    var text = KKCTextNightMode
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nastavení Růžence"
        self.tableView.tableFooterView = UIView()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userDefaults = UserDefaults.standard
        NightSwitch.isOn = userDefaults.bool(forKey: "NightSwitch")
        if NightSwitch.isOn == true {
            self.back = KKCBackgroundNightMode
            self.text = KKCTextNightMode

        }
        else {
            self.back = KKCBackgroundLightMode
            self.text = KKCTextLightMode
        }
        setupUI()

        DimOffSwitch.isOn = userDefaults.bool(forKey: "DimmScreen")
        VibrateSwitch.isOn = userDefaults.bool(forKey: "Vibrate")
        self.fontSize = userDefaults.string(forKey: "FontSize") ?? "16"
        footSwitch.isOn = userDefaults.bool(forKey: "FootFont")
        if footSwitch.isOn == true {
            self.fontName = "Times New Roman"
        } else {
            self.fontName = "Helvetica"
        }
        slider.setValue(Float(Int(self.fontSize)!), animated: true)
        labelExample.attributedText = generateContent(text: exampleText, font_name: self.fontName, size: get_cgfloat(size: self.fontSize), color: self.text)
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        self.fontSize = "\(Int(slider.value))"
        print(self.fontSize)
        userDefaults.set(self.fontSize, forKey: "FontSize")
        labelExample.attributedText = generateContent(text: exampleText, font_name: self.fontName, size: get_cgfloat(size: self.fontSize), color: self.text)
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
            self.back = KKCBackgroundNightMode
            self.text = KKCTextNightMode
            userDefaults.set(true, forKey: "NightSwitch")
            NotificationCenter.default.post(name: .darkModeEnabled, object:nil)
        }
        else {
            self.back = KKCBackgroundLightMode
            self.text = KKCTextLightMode
            userDefaults.set(false, forKey: "NightSwitch")
            NotificationCenter.default.post(name: .darkModeDisabled, object: nil)
        }
        setupUI()
    }

    @IBAction func VibrateAction(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        if VibrateSwitch.isOn == true {
            userDefaults.set(true, forKey: "Vibrate")
        }
        else {
            userDefaults.set(false, forKey: "Vibrate")
        }
    }
    
    @IBAction func footMode(_ sender: Any) {
        let userDefault = UserDefaults.standard
        if footSwitch.isOn == true {
            self.fontName = "Times New Roman"
        } else {
            self.fontName = "Helvetica"
        }
        userDefault.set(footSwitch.isOn, forKey: "FootFont")
        labelExample.attributedText = generateContent(text: exampleText, font_name: self.fontName, size: get_cgfloat(size: self.fontSize), color: self.text)

    }
    func setupUI() {
        self.view.backgroundColor = self.back
        
        self.NightSwitchLabel.textColor = self.text
        self.NightSwitchLabel.backgroundColor = self.back
        self.NightSwitch.backgroundColor = self.back
        self.NightSwitchCell.backgroundColor = self.back
        
        self.DimOffScreenLabel.textColor = self.text
        self.DimOffScreenLabel.backgroundColor = self.back
        self.DimOffSwitch.backgroundColor = self.back
        self.DimOffSwitchCell.backgroundColor = self.back
        
        self.VibrateSwitch.backgroundColor = self.back
        self.VibrateCell.backgroundColor = self.back
        self.VibrateLabel.backgroundColor = self.back
        self.VibrateLabel.textColor = self.text
        
        self.footSwitch.backgroundColor = self.back
        self.footCell.backgroundColor = self.back
        self.footLabel.backgroundColor = self.back
        self.footLabel.textColor = self.text
        self.labelExample.backgroundColor = self.back
        self.labelExample.textColor = self.text
        self.fontCell.backgroundColor = self.back
        self.fontPickerLabel.backgroundColor = self.back
        self.fontPickerLabel.textColor = self.text
    }
}
