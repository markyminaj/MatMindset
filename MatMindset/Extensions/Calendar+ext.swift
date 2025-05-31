//
//  Calendar+ext.swift
//  MatMindset
//
//  Created by Mark Martin on 5/30/25.
//

import Foundation

extension Calendar {
    func startOfWeek(for date: Date) -> Date {
        self.date(from: self.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)) ?? date
    }
}
