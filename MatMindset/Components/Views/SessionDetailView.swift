//
//  SessionDetailView.swift
//  MatMindset
//
//  Created by Mark Martin on 5/30/25.
//


import SwiftUI

struct SessionDetailView: View {
    let session: MMSessionModel

    var body: some View {
        Form {
            Section(header: Text("Session Info")) {
                HStack {
                    Label("Date", systemImage: "calendar")
                    Spacer()
                    Text(session.sessionDate?.formatted(date: .abbreviated, time: .omitted) ?? "Unknown")
                        .foregroundColor(.secondary)
                }

                HStack {
                    Label("Type", systemImage: "tag")
                    Spacer()
                    Text(session.sessionType?.rawValue.capitalized ?? "N/A")
                        .foregroundColor(.secondary)
                }

                HStack {
                    Label("Duration", systemImage: "clock")
                    Spacer()
                    Text("\(Int(session.sessionDuration ?? 0)) minutes")
                        .foregroundColor(.secondary)
                }

                HStack {
                    Label("Location", systemImage: "mappin.and.ellipse")
                    Spacer()
                    Text(session.location ?? "Unknown")
                        .foregroundColor(.secondary)
                }
            }

            if let techniques = session.techniques, !techniques.isEmpty {
                Section(header: Text("Techniques Practiced")) {
                    Text(techniques)
                        .foregroundColor(.primary)
                }
            }

            if let notes = session.sessionNotes, !notes.isEmpty {
                Section(header: Text("Notes")) {
                    Text(notes)
                        .foregroundColor(.primary)
                }
            }
        }
        .navigationTitle("Session Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
