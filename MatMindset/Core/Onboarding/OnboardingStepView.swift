//
//  OnboardingStepView.swift
//  MatMindset
//
//  Created by Mark Martin on 6/1/25.
//

import SwiftUI

struct OnboardingStepView: View {
    let title: String
    let description: String
    let imageName: String
    let buttonTitle: String
    let action: () -> Void

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 120)
                .foregroundColor(.accentColor)

            Text(title)
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)

            Text(description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()

            Button(action: action) {
                Text(buttonTitle)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
        }
        .padding()
    }
}
