//
//  WelcomeView.swift
//  MatMindset
//
//  Created by Mark Martin on 5/30/25.
//

import SwiftUI

struct WelcomeView: View {
    @AppStorage("hasOnboarded") private var hasOnboarded: Bool = false

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            // App icon or illustration
            Image(systemName: "figure.martial.arts")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.accent)

            Text("Welcome to Mat Mindset")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)

            Text("Track your training, improve your mindset, and stay accountable on your BJJ journey.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)

            Spacer()

            Button(action: {
                hasOnboarded = true
                HealthKitManager.shared.requestAuthorization { success in
                    print("HealthKit access granted? \(success)")
                }
            }) {
                Text("Get Started")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accent)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

