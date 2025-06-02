//
//  MatMindsetApp.swift
//  MatMindset
//
//  Created by Mark Martin on 4/6/25.
//

import SwiftUI

@main
struct MatMindsetApp: App {
    @State private var locationManager = LocationManager()
    @State private var sessionManager = SessionManager()

    var body: some Scene {
        WindowGroup {
            AppView()
                .environment(locationManager)
                .environment(sessionManager)

        }
    }
}
