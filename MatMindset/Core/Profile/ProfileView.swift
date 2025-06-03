//
//  ProfileView.swift
//  MatMindset
//
//  Created by Mark Martin on 5/30/25.
//

import SwiftUI

struct ProfileView: View {
    @AppStorage("userName") private var userName: String = ""
    @AppStorage("userRank") private var userRank: String = "White"
    @AppStorage("userGym") private var userGym: String = ""
    @AppStorage("monthlyGoal") private var monthlyGoal: Int = 12

    let bjjBelts = ["White", "Blue", "Purple", "Brown", "Black"]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Profile")) {
                    HStack {
                        Spacer()
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.blue)
                        Spacer()
                    }

                    TextField("Name", text: $userName)
                    
                    Picker("Belt Rank", selection: $userRank) {
                        ForEach(bjjBelts, id: \.self) { belt in
                            Text(belt)
                        }
                    }

                    TextField("Gym", text: $userGym)
                }

                Section(header: Text("Training Goal")) {
                    Stepper(value: $monthlyGoal, in: 1...30, step: 1) {
                        Text("Monthly Goal: \(monthlyGoal) sessions")
                    }
                }
            }
            .onAppear {
                HealthKitManager.shared.requestAuthorization { success in
                    print("HealthKit access granted? \(success)")
                }
            }
            .navigationTitle("Profile")
        }
    }
}


#Preview {
    ProfileView()
}
