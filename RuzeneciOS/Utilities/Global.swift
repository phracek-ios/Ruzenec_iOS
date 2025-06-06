//
//  Global.swift
//  RuzeneciOS
//
//  Created by Petr Hracek on 25/11/2019.
//  Copyright © 2019 Petr Hracek. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import SystemConfiguration


class Global {
    static func vibrate() {
        let keys = SettingsBundleHelper.SettingsBundleKeys.self
        let vibrate = UserDefaults.standard.bool(forKey: keys.vibrationEnabled)
        if vibrate {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
    }
    static func getUUID() -> String {
        let keys = SettingsBundleHelper.SettingsBundleKeys.self
        var uuidString: String  = ""
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: keys.reminderUUID) == nil {
            uuidString = UUID().uuidString
            userDefaults.set(uuidString, forKey: keys.reminderUUID)
        } else {
            uuidString = userDefaults.string(forKey: keys.reminderUUID)!
        }
        return uuidString
    }
    
    static func getIdentifier() -> String {
        let uuidString = Global.getUUID()
        return "\(uuidString)-ruzenec"
        
    }
}
