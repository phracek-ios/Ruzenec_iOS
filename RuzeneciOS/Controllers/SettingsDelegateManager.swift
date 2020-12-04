//
//  SettingsDelegateManager.swift
//  RuzeneciOS
//
//  Created by Petr Hracek on 13/11/2020.
//  Copyright © 2020 Petr Hracek. All rights reserved.
//

import Foundation
import UIKit

protocol SettingsDelegate {
    func settingsChangeDelegate(item: SettingsItem, newValue: Any?)
}

class SettingsDelegateManager: SettingsDelegate {
    
    let keys = SettingsBundleHelper.SettingsBundleKeys.self
    
    func settingsChangeDelegate(item: SettingsItem, newValue: Any?) {
        print("settingsChangeDelegate: \(item.prefsString) (new state: \(UserDefaults.standard.object(forKey: item.prefsString) ?? "DEFVAL")")
        
        if item.prefsString == keys.idleTimer {
            if let enable : Bool = newValue as? Bool {
                //Global.setupCitatNotification(enabled: enable)
                print("idleTimer \(enable) ")
                UIApplication.shared.isIdleTimerDisabled = enable
            }
        }
        
        if item.prefsString == keys.vibrationEnabled {
            if let enable : Bool = newValue as? Bool {
                //Global.setupModlitba21Notification(enabled: enable)
                print("vibrate \(enable)")
                Global.vibrate()
            }
        }
        
        if item.prefsString == keys.night {
            if let enable : Bool = newValue as? Bool {
                //Global.setupThemeModel(enabled: enable)
                print("night \(enable)")
            }
        }
    }
        
}

