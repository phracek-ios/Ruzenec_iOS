//
//  SettingsTableViewController.swift
//  RuzeneciOS
//
//  Created by Jiri Ostatnicky on 11/07/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit
import BonMot
import FirebaseAnalytics

class SettingsTableViewController: UITableViewController {
    
    
    var DarkModeOn = Bool()
    let exampleText: String = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Etiam neque"
    var fontName: String = ""
    var fontSize: String = "16"
    var back = KKCBackgroundNightMode
    var text = KKCTextNightMode
    var settings = [SettingsItem]()
    var className: String {
        return String(describing: self)
    }
    let settingsDelegate = SettingsDelegateManager()
    let keys = SettingsBundleHelper.SettingsBundleKeys.self
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nastavení Růžence"
        loadSettings()
        setupSettingsTable()
        self.tableView.tableFooterView = UIView()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters:[AnalyticsParameterScreenName: "Nastaveni Ruzence",
                                       AnalyticsParameterScreenClass: className])
        let userDefaults = UserDefaults.standard
        self.DarkModeOn = userDefaults.bool(forKey: keys.night)
        if self.DarkModeOn == true {
            self.back = KKCBackgroundNightMode
            self.text = KKCTextNightMode
        }
        else {
            self.back = KKCBackgroundLightMode
            self.text = KKCTextLightMode
        }
        setupUI()
        self.fontSize = userDefaults.string(forKey: "FontSize") ?? "16"
        self.tableView.reloadData()
        print("Settings View Will Appear")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userDefaults = UserDefaults.standard
        switch settings[indexPath.row].type {
        case .slider:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsSliderTableViewCell.cellId, for: indexPath) as! SettingsSliderTableViewCell
            cell.configureCell(settingsItem: settings[indexPath.row],
                               delegate: settingsDelegate,
                               cellWidth: tableView.frame.width)
            cell.accessoryType = .none
            return cell
        default:
            let set = settings[indexPath.row]
            print(set.prefsString)
            let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
            
            let sw = UISwitch()
            sw.isOn = userDefaults.bool(forKey: set.prefsString)
            if set.prefsString == keys.night {
                sw.addTarget(self, action: #selector(nightTarget(_:)), for: .valueChanged)
            }
            else if set.prefsString == keys.idleTimer {
                sw.addTarget(self, action: #selector(idleTarget(_:)), for: .valueChanged)
            }
            else if set.prefsString == keys.serifEnabled {
                sw.addTarget(self, action: #selector(serifTarget(_:)), for: .valueChanged)
            }
            else if set.prefsString == keys.vibrationEnabled {
                sw.addTarget(self, action: #selector(vibrateTarget(_:)), for: .valueChanged)
            }
            cell.textLabel?.text = settings[indexPath.row].title
            cell.detailTextLabel?.text = settings[indexPath.row].detail

            cell.backgroundColor = self.back
            cell.textLabel?.backgroundColor = self.back
            cell.textLabel?.textColor = self.text
            cell.detailTextLabel?.backgroundColor = self.back
            cell.detailTextLabel?.textColor = self.text

            cell.accessoryView = sw
            cell.accessoryType = .none
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if settings[indexPath.row].type == SettingsItemType.slider {
            return 150
        }
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func setupSettingsTable() {
        tableView.register(SettingsSliderTableViewCell.self, forCellReuseIdentifier: SettingsSliderTableViewCell.cellId)
    }
    
    func loadSettings() {
        settings.append(SettingsItem(type: SettingsItemType.onOffSwitch,
                                     title: "Noční režim",
                                     description: "",
                                     prefsString: keys.night,
                                     defValue: false,
                                     eventHandler: nil))
        settings.append(SettingsItem(type: SettingsItemType.onOffSwitch,
                                    title: "Zabránit vypínání obrazovky",
                                    description: "",
                                    prefsString: keys.idleTimer,
                                    defValue: false,
                                    eventHandler: nil))
        settings.append(SettingsItem(type: SettingsItemType.onOffSwitch,
                                    title: "Vibrační zpětná vazba",
                                    description: "",
                                    prefsString: keys.vibrationEnabled,
                                    defValue: false,
                                    eventHandler: nil))
        settings.append(SettingsItem(type: SettingsItemType.onOffSwitch,
                                 title: "Patkové písmo",
                                 description: "",
                                 prefsString: keys.serifEnabled,
                                 defValue: false,
                                 eventHandler: nil))
        settings.append(SettingsItem(type: SettingsItemType.slider,
                                 title: "Velikost písma",
                                 description: "Velikost písma, které bude použito u modliteb.",
                                 prefsString: keys.fontSize,
                                 defValue: false,
                                 eventHandler: nil))
        print("loadSettings finished")
    }
    
    @objc func nightTarget(_ sender: UISwitch) {
        
        print("Switch Target Night \(sender.isOn)")
        Global.vibrate()
        let userDefaults = UserDefaults.standard
        userDefaults.set(sender.isOn, forKey: keys.night)
        self.DarkModeOn = sender.isOn
        if sender.isOn == true {
            self.back = KKCBackgroundNightMode
            self.text = KKCTextNightMode
            NotificationCenter.default.post(name: .darkModeEnabled, object:nil)
        }
        else {
            self.back = KKCBackgroundLightMode
            self.text = KKCTextLightMode
            NotificationCenter.default.post(name: .darkModeDisabled, object: nil)
        }
        setupUI()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    @objc func idleTarget(_ sender: UISwitch!) {
        
        print("Idle Target Night \(sender.isOn)")
        Global.vibrate()
        let userDefaults = UserDefaults.standard
        userDefaults.set(sender.isOn, forKey: keys.idleTimer)
    }
    
    @objc func serifTarget(_ sender: UISwitch!) {
        
        print("Serif Target \(sender.isOn)")
        Global.vibrate()
        let userDefaults = UserDefaults.standard
        userDefaults.set(sender.isOn, forKey: keys.serifEnabled)
    }
    
    @objc func vibrateTarget(_ sender: UISwitch!) {
        print("Vibrate Target \(sender.isOn)")
        let userDefaults = UserDefaults.standard
        userDefaults.set(sender.isOn, forKey: keys.vibrationEnabled)
    }
    

    func setupUI() {
        self.view.backgroundColor = self.back
    }
}
