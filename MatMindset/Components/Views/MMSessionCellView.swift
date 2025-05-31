//
//  MMSessionCellView.swift
//  MatMindset
//
//  Created by Mark Martin on 5/23/25.
//

import SwiftUI

struct MMSessionCellView: View {
    var session: MMSessionModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Left Date Bubble
            VStack {
                if let date = session.sessionDate {
                    Text(date.formatted(.dateTime.month(.abbreviated)))
                        .font(.caption2)
                        .foregroundColor(.white)
                    Text(date.formatted(.dateTime.day()))
                        .font(.title2.bold())
                        .foregroundColor(.white)
                } else {
                    Text("N/A")
                        .foregroundColor(.white)
                }
            }
            .frame(width: 50, height: 50)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // Main Content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(session.sessionType?.rawValue.capitalized ?? "Unknown")
                        .font(.caption)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(badgeColor(for: session.sessionType))
                        .foregroundColor(.white)
                        .clipShape(Capsule())

                    Spacer()
                    
                    if let duration = session.sessionDuration {
                        Text("\(Int(duration)) minutes")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Text(session.techniques ?? "No techniques logged")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                if let location = session.location {
                    Text(location)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 6)
    }
    
    private func badgeColor(for type: MMSessionModel.SessionType?) -> Color {
        switch type {
        case .gi: return .blue
        case .noGi: return .orange
        case .openMat: return .green
        case .none: return .gray
        }
    }
}


#Preview {
    //MMSessionCellView(session: .mock)
}
