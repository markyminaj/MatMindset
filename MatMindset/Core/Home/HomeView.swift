//
//  HomeView.swift
//  MatMindset
//
//  Created by Mark Martin on 4/6/25.
//

import SwiftUI

struct HomeView: View {
    @State private var sessions: [MMSessionModel] = []
    @AppStorage("monthlyGoal") private var monthlyGoal: Int = 12
    @State private var isShowingAddSession = false
    
    let classSchedule = WeeklyClassSchedule(scheduledDays: [.monday, .wednesday, .friday])
    let attendanceRecords = [
        AttendanceRecord(date: Date(), attended: true),
        AttendanceRecord(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, attended: false)
    ]
    
    var body: some View {
        NavigationStack {
            
            VStack {
                trainingOverviewCard
                if !sessions.isEmpty {
                    List {
                        sessionList
                    }
                } else {
                    ContentUnavailableView("No Sessions", systemImage: "figure.walk", description: Text("Add a session below to get started"))
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
                }
                if !sessions.isEmpty {
                    ToolbarItem(placement: .topBarLeading) {
                        EditButton()
                    }
                }
            }
            .onAppear {
                sessions = SessionStorageManager.shared.loadSessions()
            }
            .sheet(isPresented: $isShowingAddSession) {
                AddSessionView(sessions: $sessions)
            }
            .onChange(of: sessions) {
                SessionStorageManager.shared.saveSessions(sessions)
            }
        }
    }
    
    private var sessionList: some View {
        Section {
            ForEach(sessions) { session in
                NavigationLink(destination: SessionDetailView(session: session)) {
                    MMSessionCellView(session: session)
                        .padding(.horizontal)
                }
            }
            .onDelete(perform: deleteSession)
        } header: {
            Text("Recent Sessions")
        }

    }
    
    var trainingOverviewCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title
            Text("This Month")
                .font(.title3.bold())

            // Stats Row
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
            
            // Goal Progress
            VStack(alignment: .leading, spacing: 4) {
                Text("Monthly Goal")
                    .font(.subheadline)
                ProgressView(value: Double(sessionsThisMonth.count), total: Double(monthlyGoal))
                    .accentColor(.purple)
                Text("\(sessionsThisMonth.count)/\(monthlyGoal)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
    }

    // Filter sessions for this month
    var sessionsThisMonth: [MMSessionModel] {
        let calendar = Calendar.current
        return sessions.filter {
            if let date = $0.sessionDate {
                return calendar.isDate(date, equalTo: Date(), toGranularity: .month)
            }
            return false
        }
    }

    // Calculate total minutes trained
    var totalMinutesThisMonth: Int {
        sessionsThisMonth.reduce(0) { total, session in
            total + Int(session.sessionDuration ?? 100) // ✅ convert from seconds
        }
    }

    
    private func deleteSession(at offsets: IndexSet) {
        sessions.remove(atOffsets: offsets)
    }
}


#Preview {
    HomeView()
}
