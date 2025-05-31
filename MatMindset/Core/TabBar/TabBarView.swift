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
