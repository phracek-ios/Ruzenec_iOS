//
//  SettingsBundleHelper.swift
//  RuzeneciOS
//
//  Created by Petr Hracek on 13/11/2020.
//  Copyright © 2020 Petr Hracek. All rights reserved.
//

import Foundation

class SettingsBundleHelper {
    
    struct SettingsBundleKeys {
        static let vibrationEnabled = "ruzenecAppSettingVibrace"
        static let notificationSound = "ruzenecAppSettingNotificationSound"
        static let idleTimer = "ruzenecAppSettingsIdleTimer"
        static let night = "ruzenecAppSettingNightMode"
        static let serifEnabled = "ruzenecAppSettingSerifEnabled"
        static let fontSize = "ruzenecAppSettingFontSize"

        static let appGuid = "ruzenecAppGuid"
        static let appGuidVersion = "ruzenecAppGuidVersion"
        static let appVersion = "ruzenecAppVersion"
        static let rateAppPref = "ruzenecRunsToShowRateApp"
        static let pompejCounter = "ruzenecPompejCounter"
        static let voice = "ruzenecAppVoice"
        static let desatekCounter = "ruzenecDesatekCounter"
        static let reminderHour = "ruzenecAppHour"
        static let reminderMinute = "ruzenecAppMinute"
        static let reminderEnabled = "ruzenecAppReminderEnabled"
        static let reminderUUID = "ruzenecAppUUID"
        static let countRuzenec = "ruzenecAppcountRuzenec"
    }
    
}
