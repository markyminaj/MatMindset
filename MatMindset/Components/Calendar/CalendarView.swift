//
//  CalendarView.swift
//  MatMindset
//
//  Created by Mark Martin on 5/30/25.
//

import SwiftUI

struct CalendarView: View {
    @State private var currentMonth = Date()
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        VStack {
            // Header with month/year and navigation
            HStack {
                Button(action: { changeMonth(by: -1) }) {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text(currentMonth, style: .date)
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                Button(action: { changeMonth(by: 1) }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal)
            
            // Day of week headers
            HStack {
                ForEach(Calendar.current.shortWeekdaySymbols, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Calendar grid
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(generateCalendarDays(for: currentMonth)) { day in
                    ZStack {
                        if let date = day.date {
                            Text("\(Calendar.current.component(.day, from: date))")
                                .frame(maxWidth: .infinity)
                                .padding(8)
                                .background(day.isWithinCurrentMonth ? Color.blue.opacity(0.1) : Color.clear)
                                .clipShape(Circle())
                        } else {
                            Color.clear.frame(height: 40)
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    func generateCalendarDays(for month: Date, calendar: Calendar = .current) -> [CalendarDay] {
        let startOfMonth = month.startOfMonth(using: calendar)
        let daysInMonth = month.numberOfDaysInMonth(using: calendar)
        let weekdayOffset = calendar.component(.weekday, from: startOfMonth) - calendar.firstWeekday
        
        var days: [CalendarDay] = []
        
        // Offset days before the 1st of the month
        for _ in 0..<((weekdayOffset + 7) % 7) {
            days.append(CalendarDay(date: nil, isWithinCurrentMonth: false))
        }
        
        // Actual days in the month
        for day in 1...daysInMonth {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                days.append(CalendarDay(date: date, isWithinCurrentMonth: true))
            }
        }
        
        return days
    }
    
    private func changeMonth(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newDate
        }
    }
}

struct WeekHeaderView: View {
    let classSchedule: WeeklyClassSchedule
    let attendanceRecords: [AttendanceRecord]

    var body: some View {
        let currentWeek = generateCurrentWeek()

        HStack(spacing: 12) {
            ForEach(currentWeek, id: \.self) { date in
                let color = colorForDate(date, schedule: classSchedule, attendance: attendanceRecords)
                let dayNumber = Calendar.current.component(.day, from: date)
                let weekday = Weekday(rawValue: Calendar.current.component(.weekday, from: date))!

                VStack {
                    Text(weekday.shortName)
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text("\(dayNumber)")
                        .frame(width: 36, height: 36)
                        .background(Circle().fill(color))
                        .foregroundColor(.white)
                        .font(.headline)
                }
            }
        }
        .padding()
    }

    func generateCurrentWeek() -> [Date] {
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)

        let startOfWeek = calendar.date(byAdding: .day, value: -(weekday - calendar.firstWeekday + 7) % 7, to: today) ?? today

        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }

    func colorForDate(_ date: Date, schedule: WeeklyClassSchedule, attendance: [AttendanceRecord]) -> Color {
        let calendar = Calendar.current
        let weekday = Weekday(rawValue: calendar.component(.weekday, from: date))!

        let isScheduled = schedule.scheduledDays.contains(weekday)
        let attended = attendance.contains(where: {
            calendar.isDate($0.date, inSameDayAs: date) && $0.attended
        })

        if isScheduled && attended {
            return .green
        } else if isScheduled && !attended {
            return .red
        } else {
            return .gray.opacity(0.2)
        }
    }
}
