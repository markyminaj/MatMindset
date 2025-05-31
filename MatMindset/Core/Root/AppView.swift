//
//  AppView.swift
//  MatMindset
//
//  Created by Mark Martin on 5/30/25.
//


import SwiftUI

struct AppView: View {

    //@State var appState: AppState = AppState()
    @AppStorage("hasOnboarded") private var hasOnboarded: Bool = false

    
    var body: some View {
        AppViewBuilder(
            showTabbar: hasOnboarded,
            tabbarView: {
                TabBarView()
            },
            onboardingView: {
                WelcomeView()
            }
        )
    }
}
