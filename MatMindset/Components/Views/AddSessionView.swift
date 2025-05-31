//
//  AddSessionView.swift
//  MatMindset
//
//  Created by Mark Martin on 5/30/25.
//

import SwiftUI
import HealthKit

struct AddSessionView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var sessions: [MMSessionModel]
    
    @State private var sessionDate: Date = Date()
    @State private var sessionType: MMSessionModel.SessionType = .gi
    @State private var sessionDuration: Int = 90 // 90 minutes = 1.5 hrs
    @State private var techniques: String = ""
    @State private var sessionNotes: String = ""
    @State private var location: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                infoSection
                techSection
                notesSection
            }
            .navigationTitle("New Session")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveButtonPressed()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func saveButtonPressed() {
        let newSession = MMSessionModel(
            id: UUID().uuidString,
            sessionDate: sessionDate,
            sessionDuration: sessionDuration,
            sessionNotes: sessionNotes,
            sessionType: sessionType,
            techniques: techniques,
            location: location
        )
        sessions.append(newSession)
        
        // Save to HealthKit
        HealthKitManager.shared.saveWorkout(start: sessionDate, end: sessionDate, duration: TimeInterval(sessionDuration) * 60, calories: 500)
    }
    
    private var infoSection: some View {
        Section(header: Text("Session Info")) {
            DatePicker("Date", selection: $sessionDate, displayedComponents: .date)
            
            Stepper(value: $sessionDuration, in: 15...180, step: 15) {
                Text("Duration: \(sessionDuration) minutes")
            }
            
            Picker("Session Type", selection: $sessionType) {
                ForEach(MMSessionModel.SessionType.allCases) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(.segmented)
            
            
            TextField("Location", text: $location)
        }
    }
    
    private var techSection: some View {
        Section(header: Text("Techniques")) {
            TextField("e.g. Armbar from mount, hip bump sweep", text: $techniques)
        }
    }
    
    private var notesSection: some View {
        Section(header: Text("Notes")) {
            TextEditor(text: $sessionNotes)
                .frame(height: 100)
        }
    }
}
