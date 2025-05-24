//
//  ContentView.swift
//  MatMindset
//
//  Created by Mark Martin on 4/6/25.
//

import SwiftUI

struct ContentView: View {
    let sessions: [MMSessionModel] = MMSessionModel.mockSessions
    var body: some View {
        NavigationStack {
            List(sessions, id: \.self) { session in
                Text(session.sessionNotes ?? "No notes")
            }
            .navigationTitle("Mat Mindset")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
