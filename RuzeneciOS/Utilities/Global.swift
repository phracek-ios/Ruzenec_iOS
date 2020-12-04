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
}
