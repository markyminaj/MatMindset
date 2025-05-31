//
//  Weekday.swift
//  MatMindset
//
//  Created by Mark Martin on 5/30/25.
//

import SwiftUI

enum Weekday: Int, CaseIterable, Codable {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday

    var shortName: String {
        let formatter = DateFormatter()
        return formatter.shortWeekdaySymbols[self.rawValue - 1]
    }
}

struct WeeklyClassSchedule: Codable {
    var scheduledDays: [Weekday]  // e.g. [.monday, .wednesday, .friday]
}

struct AttendanceRecord: Identifiable, Codable {
    var id = UUID()
    let date: Date
    let attended: Bool
}
