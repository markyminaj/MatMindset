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
    @AppStorage("monthlyGoal") private var monthlyGoal: Int = 12

    @State private var showingGymPicker = false // Added for sheet presentation
    @AppStorage("favoriteGyms") private var favoriteGymsData: Data = Data() // Added for gym data

    let bjjBelts = ["White", "Blue", "Purple", "Brown", "Black"]

    private var favoriteGyms: [GymLocation] { // Added computed property
        if let decoded = try? JSONDecoder().decode([GymLocation].self, from: favoriteGymsData) {
            return decoded
        }
        return []
    }

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
                }

                Section(header: Text("Training Goal")) {
                    Stepper(value: $monthlyGoal, in: 1...30, step: 1) {
                        Text("Monthly Goal: \(monthlyGoal) sessions")
                    }
                }

                Section(header: Text("Favorite Gyms")) { // Added Favorite Gyms section
                    if favoriteGyms.isEmpty {
                        Text("No favorite gyms yet. Add one!")
                    } else {
                        ForEach(favoriteGyms) { gym in
                            HStack {
                                Text(gym.name)
                                Spacer()
                                Text("Lat: \(gym.latitude, specifier: "%.2f"), Lon: \(gym.longitude, specifier: "%.2f")")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    Button("Manage Favorite Gyms") {
                        showingGymPicker = true
                    }
                }
            }
            .onAppear {
                HealthKitManager.shared.requestAuthorization { success in
                    print("HealthKit access granted? \(success)")
                }
            }
            .navigationTitle("Profile")
            .sheet(isPresented: $showingGymPicker) { // Added sheet modifier
                SimpleGymPickerView(selectedGym: .constant(nil))
            }
        }
    }
}


#Preview {
    ProfileView()
}
