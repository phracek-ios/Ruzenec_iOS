//
//  DateManager.swift
//  RuzeneciOS
//
//  Created by Petr Hracek on 28.05.2025.
//  Copyright © 2025 Petr Hracek. All rights reserved.
//

import Foundation
import UIKit

func get_month() -> Int {
    let date = Date()
    let calendar = Calendar.current
    return calendar.component(.month, from: date)
}

func get_year() -> Int {
    let date = Date()
    let calendar = Calendar.current
    return calendar.component(.year, from: date)
}

func get_day() -> Int {
    let date = Date()
    let calendar = Calendar.current
    return calendar.component(.day, from: date)
}

func get_day_by_Adding_day(value: Int = 1) -> (Int, Int) {
    let startDate = Date()
    let nextDate = Calendar.current.date(byAdding: .day, value: value, to: startDate)
    return (Calendar.current.component(.month, from: nextDate!), Calendar.current.component(.day, from: nextDate!))
}

func getMonthName(month: Int) -> String {
    let fmt = DateFormatter()
    fmt.locale = Locale(identifier: "cs")
    print(mount)
    return fmt.standaloneMonthSymbols[month - 1].capitalized
}
