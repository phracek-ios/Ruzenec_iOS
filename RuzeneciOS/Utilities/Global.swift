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

class SettingsBundleHelper {
    struct SettingsBundleKeys {
        static let vibrationEnabled = "ruzenecAppSettingVibrace"
    }
}

class Global {
    static func vibrate() {
        let vibrate = UserDefaults.standard.bool(forKey: "Vibrate")
        if vibrate {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
    }
}
