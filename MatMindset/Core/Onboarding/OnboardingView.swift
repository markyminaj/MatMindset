//
//  OnboardingView.swift
//  MatMindset
//
//  Created by Mark Martin on 6/1/25.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var step: Int = 1
    @Namespace private var animation

    var body: some View {
        ZStack {
            if step == 1 {
                OnboardingStepView(
                    title: "Welcome to Mat Mindset",
                    description: "Track your Brazilian Jiu-Jitsu training, log techniques, and stay consistent with your goals.",
                    imageName: "figure.martial.arts",
                    buttonTitle: "Next"
                ) {
                    withAnimation(.easeInOut) {
                        step = 2
                    }
                }
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            }

            if step == 2 {
                OnboardingStepView(
                    title: "Verify Your Training",
                    description: "Check in at your gym by taking a photo and confirming your location to keep yourself accountable. You can only log a session once you've checked in!",
                    imageName: "camera.viewfinder",
                    buttonTitle: "Next"
                ) {
                    withAnimation(.easeInOut) {
                        step = 3
                    }
                }
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            }

            if step == 3 {
                OnboardingStepView(
                    title: "Hit Your Goals",
                    description: "Set a monthly goal and track your sessions and training time to stay on top of your progress.",
                    imageName: "target",
                    buttonTitle: "Get Started"
                ) {
                    withAnimation {
                        hasCompletedOnboarding = true
                    }
                }
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            }
        }
    }
}

