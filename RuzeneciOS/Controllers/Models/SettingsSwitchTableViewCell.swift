//
//  SettingsSwitchTableViewCell.swift
//  RuzeneciOS
//
//  Created by Petr Hracek on 13/11/2020.
//  Copyright © 2020 Petr Hracek. All rights reserved.
//

import Foundation
import UIKit

class SettingsSwitchTableViewCell: UITableViewCell {

    static let cellId = "settingsSwitchItem"
    let keys = SettingsBundleHelper.SettingsBundleKeys.self
    
    var title: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 18)
        l.backgroundColor = .clear
        return l
    }()
    
    var detail: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14)
        l.numberOfLines = 0
        return l
    }()
    
    let itemSwitch = UISwitch()
    var delegate: SettingsDelegate?
    
    var settingsItem: SettingsItem?
    
    func configureCell(settingsItem: SettingsItem, delegate: SettingsDelegate, cellWidth: CGFloat) {
        self.settingsItem = settingsItem
        self.delegate = delegate
        self.textLabel?.text = settingsItem.title
        self.accessoryView = itemSwitch
        title.text = settingsItem.title
        detail.text = settingsItem.detail

        backgroundColor = .clear
        selectionStyle = .none
        title.textColor = KKCMainTextColor
        var isOn : Bool = (settingsItem.defValue as? Bool)!
        if UserDefaults.standard.object(forKey: settingsItem.prefsString) != nil {
            isOn = UserDefaults.standard.bool(forKey: settingsItem.prefsString)
        }
        itemSwitch.isOn = isOn
        
        itemSwitch.addTarget(self, action: #selector(self.switchTarget(_:)), for: .valueChanged)
        
    }

    @objc func switchTarget(_ sender: UISlider!) {
        //print("Switch Target")
        Global.vibrate()
        if settingsItem?.prefsString == keys.night {
            if itemSwitch.isOn == false {
                //title.backgroundColor = KKCBackgroundLightMode
                self.backgroundColor = KKCBackgroundLightMode
                title.textColor = KKCTextLightMode
            }
            else {
                //title.backgroundColor = KKCBackgroundNightMode
                self.backgroundColor = KKCBackgroundNightMode
                title.textColor = KKCTextNightMode

            }
        }
        UserDefaults.standard.set(itemSwitch.isOn,  forKey: settingsItem!.prefsString)
        if delegate != nil && settingsItem != nil {
            delegate?.settingsChangeDelegate(item: settingsItem!, newValue: itemSwitch.isOn)
        }
    }

}
