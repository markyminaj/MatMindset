//
//  AddSessionView.swift
//  MatMindset
//
//  Created by Mark Martin on 5/30/25.
//

import SwiftUI
import HealthKit
import CoreLocation

struct AddSessionView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(LocationManager.self) private var locationManager

    @Binding var sessions: [MMSessionModel]
    @Binding var checkInPhoto: UIImage?
    @Binding var checkInLocation: CLLocationCoordinate2D?

    @State private var sessionDate: Date = Date()
    @State private var sessionType: MMSessionModel.SessionType = .gi
    @State private var sessionDuration: Int = 90
    @State private var techniques: String = ""
    @State private var sessionNotes: String = ""
    @State private var location: String = ""

    var body: some View {
        NavigationStack {
            Form {
                infoSection
                techSection
                notesSection
                checkInSection
            }
            .navigationTitle("New Session")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveButtonPressed()
                        dismiss()
                    }
                    .disabled(checkInPhoto == nil || checkInLocation == nil)
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
        let id = UUID().uuidString
        let filename = checkInPhoto.flatMap { PhotoStorageManager.savePhoto($0, id: UUID(uuidString: id) ?? UUID()) }

        let newSession = MMSessionModel(
            id: id,
            sessionDate: sessionDate,
            sessionDuration: sessionDuration,
            sessionNotes: sessionNotes,
            sessionType: sessionType,
            techniques: techniques,
            location: locationManager.currentLocationName,
            checkInPhotoFilename: filename,
            checkInLocationLatitude: checkInLocation?.latitude,
            checkInLocationLongitude: checkInLocation?.longitude
        )

        sessions.append(newSession)

        HealthKitManager.shared.saveWorkout(
            start: sessionDate,
            end: sessionDate,
            duration: TimeInterval(sessionDuration) * 60,
            calories: 500
        )

        // Clear check-in photo and location for the next session
        checkInPhoto = nil
        checkInLocation = nil
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
            TextEditor(text: $techniques)
                .frame(height: 100)
        }
    }

    private var notesSection: some View {
        Section(header: Text("Notes")) {
            TextEditor(text: $sessionNotes)
                .frame(height: 100)
        }
    }

    private var checkInSection: some View {
        Section(header: Text("Check-In Info")) {
            if let photo = checkInPhoto {
                Image(uiImage: photo)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 200)
                    .cornerRadius(12)
            } else {
                Text("No check-in photo available.")
                    .foregroundColor(.secondary)
            }
        }
    }
}

