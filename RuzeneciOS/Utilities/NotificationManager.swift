//
//  NotificationManager.swift
//  RuzeneciOS
//
//  Created by Petr Hracek on 28.05.2025.
//  Copyright © 2025 Petr Hracek. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications


class NotificationManager {
    
    static func addNotification(msg: String, day: Int, month: Int, hour: Int, minute: Int) {
        let uuidString = Global.getUUID()
        debugPrint("NotificationManager-addNotification:Stored UUID is: \(uuidString) and msg \(msg)-\(month)-\(day)-\(hour)-\(minute)")
        // debugPrint("Planned notification \(day)-\(month)-\(hour)-\(minute)")
        let content = UNMutableNotificationContent()
        content.title = "Růženec připomínka"
        content.body = msg
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = notificationAlarm
        var dateComponents = DateComponents()
        dateComponents.day = day
        dateComponents.month = month
        dateComponents.minute = minute
        dateComponents.hour = hour
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: "\(uuidString)-\(notificationAlarm)", content: content, trigger: trigger)
        center.add(request)
        // debugPrint("---Notification finished----")
    }
    
    static func removeNotifications() {
        debugPrint("Remote all notifications")
        let uuidString = Global.getUUID()
        center.removePendingNotificationRequests(withIdentifiers: ["\(uuidString)-\(notificationAlarm)"])
    }
    
    static func updateRuzenec() {
        NotificationManager.removeNotifications()
        let userDefaults = UserDefaults.standard
        let keys = SettingsBundleHelper.SettingsBundleKeys.self
        let user_hour = userDefaults.integer(forKey: keys.reminderHour)
        let user_minute = userDefaults.integer(forKey: keys.reminderMinute)
        var count: Int = 7
        if userDefaults.object(forKey: keys.countRuzenec) != nil {
            count = userDefaults.integer(forKey: keys.countRuzenec)
        }
        for i in 1...count {
            let (current_month, current_day) = get_day_by_Adding_day(value: i)
            let msg: String = "Najděte si čas na modlitbu růžence"
            debugPrint("NotificationManager-updateNovenas: Setup notification for day \(current_month)-\(current_day):'\(user_hour):\(user_minute)'")
            NotificationManager.addNotification(msg: msg, day: current_day, month: current_month, hour: user_hour, minute: user_minute)
        }
    }
}
let center = UNUserNotificationCenter.current()
let notificationAlarm = "ruzenec_alarm"

