//
//  CalendarDay.swift
//  MatMindset
//
//  Created by Mark Martin on 5/30/25.
//

import SwiftUI

struct CalendarDay: Identifiable {
    let id = UUID()
    let date: Date?
    let isWithinCurrentMonth: Bool
}

