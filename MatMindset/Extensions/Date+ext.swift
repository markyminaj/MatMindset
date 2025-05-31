//
//  Date+ext.swift
//  MatMindset
//
//  Created by Mark Martin on 5/30/25.
//

import Foundation

extension Date {
    func startOfMonth(using calendar: Calendar = .current) -> Date {
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components)!
    }

    func endOfMonth(using calendar: Calendar = .current) -> Date {
        var components = DateComponents()
        components.month = 1
        components.day = -1
        return calendar.date(byAdding: components, to: startOfMonth(using: calendar))!
    }

    func numberOfDaysInMonth(using calendar: Calendar = .current) -> Int {
        calendar.range(of: .day, in: .month, for: self)?.count ?? 0
    }

    func weekday(using calendar: Calendar = .current) -> Int {
        calendar.component(.weekday, from: self)
    }
}
