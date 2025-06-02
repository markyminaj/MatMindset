//
//  SessionGalleryView.swift
//  MatMindset
//
//  Created by Mark Martin on 6/1/25.
//

import SwiftUI

struct SessionGalleryView: View {
    var sessions: [MMSessionModel]

    // Use only sessions that have a saved photo
    private var photoSessions: [MMSessionModel] {
        sessions.filter { $0.checkInPhotoFilename != nil }
    }

    private let gridColumns = [
        GridItem(.adaptive(minimum: 120), spacing: 12)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridColumns, spacing: 12) {
                ForEach(photoSessions) { session in
                    if let filename = session.checkInPhotoFilename,
                       let image = PhotoStorageManager.loadPhoto(named: filename) {
                        VStack(alignment: .leading, spacing: 4) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipped()
                                .cornerRadius(10)

                            if let date = session.sessionDate {
                                Text(date.formatted(date: .abbreviated, time: .omitted))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Session Gallery")
    }
}

