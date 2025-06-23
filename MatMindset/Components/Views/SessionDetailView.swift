//
//  SessionDetailView.swift
//  MatMindset
//
//  Created by Mark Martin on 5/30/25.
//

import SwiftUI
import MapKit
import CoreLocation

struct SessionDetailView: View {
    let session: MMSessionModel


    var checkInCoordinate: CLLocationCoordinate2D? {
        guard
            let lat = session.checkInLocationLatitude,
            let lon = session.checkInLocationLongitude
        else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }

    var checkInPhoto: UIImage? {
        guard let filename = session.checkInPhotoFilename else { return nil }
        return PhotoStorageManager.loadPhoto(named: filename)
    }

    var body: some View {
        Form {
            // MARK: - Check-In Info Section
            if checkInPhoto != nil || checkInCoordinate != nil {
                Section(header: Text("Check-In Details")) {
                    if let image = checkInPhoto {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 200)
                            .cornerRadius(12)
                    }

                    if let coord = checkInCoordinate {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Latitude: \(coord.latitude)")
                            Text("Longitude: \(coord.longitude)")
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)

                        let position = MapCameraPosition.region(MKCoordinateRegion(
                            center: coord,
                            span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
                        ))
                        Map(position: .constant(position), interactionModes: []) {
                            Annotation("Check-In Location", coordinate: coord) {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.blue)
                            }
                        }
                        .frame(height: 150)
                        .cornerRadius(10)
                    }
                }
            }

            // MARK: - Core Session Info
            Section(header: Text("Session Info")) {
                infoRow(label: "Date", systemImage: "calendar", value: session.sessionDate?.formatted(date: .abbreviated, time: .omitted) ?? "Unknown")

                infoRow(label: "Type", systemImage: "tag", value: session.sessionType?.rawValue.capitalized ?? "N/A")

                infoRow(label: "Duration", systemImage: "clock", value: "\(Int(session.sessionDuration ?? 0)) minutes")

                infoRow(label: "Location", systemImage: "mappin.and.ellipse", value: session.location ?? "Unknown")
            }

            // MARK: - Techniques
            if let techniques = session.techniques, !techniques.isEmpty {
                Section(header: Text("Techniques Practiced")) {
                    Text(techniques)
                }
            }

            // MARK: - Notes
            if let notes = session.sessionNotes, !notes.isEmpty {
                Section(header: Text("Notes")) {
                    Text(notes)
                }
            }
        }
        .navigationTitle("Session Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func infoRow(label: String, systemImage: String, value: String) -> some View {
        HStack {
            Label(label, systemImage: systemImage)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}
