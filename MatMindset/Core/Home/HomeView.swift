//
//  HomeView.swift
//  MatMindset
//
//  Created by Mark Martin on 4/6/25.
//

import SwiftUI
import CoreLocation

struct HomeView: View {
    @State private var sessions: [MMSessionModel] = []
    @AppStorage("monthlyGoal") private var monthlyGoal: Int = 12
    @State private var isShowingAddSession = false
    @State private var hasShownAlert = false
    @State private var isCheckedIn = false
    @State private var showingCamera = false
    @State private var checkInPhoto: UIImage?
    @State private var checkInLocation: CLLocation?
    @State private var checkInTime: Date?
    
    
    @Environment(LocationManager.self) private var locationManager
    
    let classSchedule = WeeklyClassSchedule(scheduledDays: [.monday, .wednesday, .friday])
    let attendanceRecords = [
        AttendanceRecord(date: Date(), attended: true),
        AttendanceRecord(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, attended: false)
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                HeaderSummaryView(
                    streak: currentStreak,
                    sessionsThisMonth: sessionsThisMonth.count,
                    totalMinutes: totalMinutesThisMonth
                )

                MonthlyGoalCard(
                    currentSessions: sessionsThisMonth.count,
                    goal: monthlyGoal
                )

                checkinView
                //trainingOverviewCard
                
                if !sessions.isEmpty {
                    List {
                        sessionList
                    }
                } else {
                    ContentUnavailableView("No Sessions", systemImage: "figure.walk", description: Text("Check in at your gym and log a session."))
                }
            }
            .navigationTitle("Mat Mindset")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingAddSession.toggle()
                    } label: {
                        Label("Add Session", systemImage: "plus")
                    }
                    .disabled(!isCheckedIn)
                    
                }
                
                if !sessions.isEmpty {
                    ToolbarItem(placement: .topBarLeading) {
                        EditButton()
                    }
                }
            }
            .sheet(isPresented: $isShowingAddSession) {
                AddSessionView(
                    sessions: $sessions,
                    checkInPhoto: $checkInPhoto,
                    checkInLocation: Binding(
                        get: {
                            checkInLocation?.coordinate
                        },
                        set: { newValue in
                            if let newCoord = newValue {
                                checkInLocation = CLLocation(latitude: newCoord.latitude, longitude: newCoord.longitude)
                            } else {
                                checkInLocation = nil
                            }
                        }
                    )
                )
            }

            .onChange(of: sessions) {
                SessionStorageManager.shared.saveSessions(sessions)
            }
            .task {
                sessions = SessionStorageManager.shared.loadSessions()
                // Request location access and optionally set the gym location if needed
                locationManager.requestAuthorization()
                locationManager.startUpdatingLocation() // ✅ THIS IS CRITICAL
                
                
                // Example gym, should be dynamic
                let storeLatitude = 32.6226760
                let storeLongitude = -116.9999206
                let gym = CLLocationCoordinate2D(latitude: storeLatitude, longitude: storeLongitude)
                locationManager.setGymLocation(latitude: gym.latitude, longitude: gym.longitude)
                
                if isCheckedIn {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 60 * 60) { // 1 hour later
                        isCheckedIn = false
                    }
                }
                if let checkInTime = checkInTime,
                   !Calendar.current.isDateInToday(checkInTime) {
                    isCheckedIn = false
                    checkInPhoto = nil
                    checkInLocation = nil
                    self.checkInTime = nil
                }
                
            }
            .onChange(of: locationManager.isAtGym) { atGym, _ in
                print("🔁 onChange fired - atGym: \(atGym)") // ✅ debug line
                if atGym {
                    locationManager.stopUpdatingLocation()
                }
                
            }
        }
    }
    
    private var sessionList: some View {
        Section {
            ForEach(sessions) { session in
                NavigationLink(destination: SessionDetailView(session: session)) {
                    MMSessionCellView(session: session)
                }
            }
            .onDelete(perform: deleteSession)
        } header: {
            Text("Recent Sessions")
        }
    }
    
    private var daysWithTrainingThisMonth: Set<Date> {
        let calendar = Calendar.current
        let sessionsThisMonth = sessions.filter {
            if let date = $0.sessionDate {
                return calendar.isDate(date, equalTo: Date(), toGranularity: .month)
            }
            return false
        }
        return Set(sessionsThisMonth.compactMap { $0.sessionDate?.startOfDay })
    }

    private var currentStreak: Int {
        let today = Date().startOfDay
        var streak = 0
        var day = today

        while daysWithTrainingThisMonth.contains(day) {
            streak += 1
            day = Calendar.current.date(byAdding: .day, value: -1, to: day)!
        }

        return streak
    }

    private var progressMessage: String {
        let percent = Double(sessionsThisMonth.count) / Double(monthlyGoal)

        switch percent {
        case ..<0.25:
            return "Let's get moving! 💪"
        case ..<0.5:
            return "Nice start! Keep it up! 🚀"
        case ..<0.75:
            return "You're halfway there! 🧗‍♂️"
        case ..<1.0:
            return "Almost at your goal! 🎯"
        default:
            return "Goal crushed! 🥋🔥"
        }
    }
    
    private var checkinView: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: locationManager.isAtGym || isCheckedIn ? "location.fill" : "location.slash")
                    .foregroundColor((locationManager.isAtGym || isCheckedIn) ? .green : .red)

                Text(
                    isCheckedIn
                        ? "Currently checked in"
                        : (locationManager.isAtGym ? "You are at the gym. Check in?" : "Not at the gym.")
                )
                .font(.subheadline)
                .foregroundColor(.secondary)
            }

            Button {
                if isCheckedIn {
                    checkOut()
                } else {
                    showingCamera = true
                }
            } label: {
                Label(
                    isCheckedIn ? "Check Out" : "Check In",
                    systemImage: isCheckedIn ? "rectangle.portrait.and.arrow.right" : "camera"
                )
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isCheckedIn ? Color.red.opacity(0.2) : (locationManager.isAtGym ? Color.green.opacity(0.2) : Color.gray.opacity(0.2)))
                )
            }
            .foregroundColor(isCheckedIn ? .red : (locationManager.isAtGym ? .green : .gray))
            .disabled(!locationManager.isAtGym && !isCheckedIn)
        }
        .sheet(isPresented: $showingCamera) {
            CameraView { image in
                if let image = image {
                    checkInPhoto = image
                    isCheckedIn = true
                    checkInTime = Date()
                    checkInLocation = locationManager.currentLocation

                    if let coordinate = locationManager.currentLocation?.coordinate {
                        locationManager.fetchLocationName(for: coordinate)
                    }
                }
            }
        }
    }

    private var trainingOverviewCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(progressMessage)
                        .font(.title3.bold())
                    Text("You've trained \(sessionsThisMonth.count) out of \(monthlyGoal) sessions this month.")
                        .font(.subheadline)
                }
                Spacer()
                if sessionsThisMonth.count >= monthlyGoal {
                    Image(systemName: "trophy.fill")
                        .foregroundColor(.yellow)
                        .imageScale(.large)
                }
            }

            ProgressView(value: Double(sessionsThisMonth.count), total: Double(monthlyGoal))
                .accentColor(sessionsThisMonth.count >= monthlyGoal ? .green : .purple)

            HStack {
                Label("\(sessionsThisMonth.count)", systemImage: "calendar")
                    .foregroundColor(.blue)
                Text("Sessions")
                Spacer()
                Label("\(totalMinutesThisMonth) min", systemImage: "clock")
                    .foregroundColor(.green)
                Text("Trained")
            }
            .font(.subheadline)

            Divider()

            VStack(alignment: .leading, spacing: 4) {
                Text("Current Streak")
                    .font(.subheadline)
                HStack {
                    Label("\(currentStreak)", systemImage: "flame.fill")
                        .foregroundColor(currentStreak > 0 ? .red : .gray)
                    Text(currentStreak > 1 ? "days in a row!" : "day")
                }
                .font(.headline)
            }

            Divider()

            Text("Monthly Goal: \(monthlyGoal) sessions")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 4)
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
    }


    
    private var sessionsThisMonth: [MMSessionModel] {
        let calendar = Calendar.current
        return sessions.filter {
            if let date = $0.sessionDate {
                return calendar.isDate(date, equalTo: Date(), toGranularity: .month)
            }
            return false
        }
    }
    
    private var totalMinutesThisMonth: Int {
        sessionsThisMonth.reduce(0) { total, session in
            total + Int(session.sessionDuration ?? 100)
        }
    }
    
    private func deleteSession(at offsets: IndexSet) {
        sessions.remove(atOffsets: offsets)
    }
    
    private func checkOut() {
        isCheckedIn = false
        checkInPhoto = nil
        checkInLocation = nil
        checkInTime = nil
        locationManager.startUpdatingLocation()
    }

}


struct HeaderSummaryView: View {
    var streak: Int
    var sessionsThisMonth: Int
    var totalMinutes: Int
    
    var body: some View {
        HStack(spacing: 24) {
            VStack {
                Image(systemName: "flame.fill")
                    .foregroundColor(.orange)
                Text("\(streak)")
                    .font(.headline)
                Text("Day Streak")
                    .font(.caption)
            }

            VStack {
                Image(systemName: "calendar")
                    .foregroundColor(.blue)
                Text("\(sessionsThisMonth)")
                    .font(.headline)
                Text("Sessions")
                    .font(.caption)
            }

            VStack {
                Image(systemName: "clock")
                    .foregroundColor(.green)
                Text("\(totalMinutes)")
                    .font(.headline)
                Text("Minutes")
                    .font(.caption)
            }
        }
        .padding(.horizontal)
        .padding(.top)
    }
}

struct MonthlyGoalCard: View {
    var currentSessions: Int
    var goal: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Monthly Goal")
                .font(.subheadline.bold())

            ProgressView(value: Double(currentSessions), total: Double(goal))
                .accentColor(.purple)

            Text("\(currentSessions)/\(goal) sessions")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
    }
}




// Preview
#Preview {
    HomeView()
        .environment(LocationManager())
}

