//
//  AppView.swift
//  MatMindset
//
//  Created by Mark Martin on 5/30/25.
//


import SwiftUI

struct AppView: View {

    //@State var appState: AppState = AppState()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    
    var body: some View {
        AppViewBuilder(
            showTabbar: hasCompletedOnboarding,
            tabbarView: {
                TabBarView()
            },
            onboardingView: {
                OnboardingView()
            }
        )
    }
}
