//
//  TabBarView.swift
//  MatMindset
//
//  Created by Mark Martin on 5/30/25.
//

import SwiftUI

struct TabBarView: View {
    let sessions = SessionStorageManager.shared.loadSessions()
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            SessionGalleryView(sessions: sessions)
                .tabItem {
                    Label("Sessions", systemImage: "square.and.arrow.up.on.square")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
            
        }
    }
}

#Preview {
    TabBarView()
}
