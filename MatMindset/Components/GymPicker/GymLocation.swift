//
//  GymLocation.swift
//  MatMindset
//
//  Created by Mark Martin on 5/30/25.
//

import SwiftUI

struct GymLocation: Codable, Equatable, Identifiable {
    var id: UUID = UUID() // Add this
    var name: String
    var latitude: Double   // Add this
    var longitude: Double  // Add this
}

struct SimpleGymPickerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedGym: GymLocation?

    @State private var gymName: String = ""
    @State private var gymLatitude: String = "" // Add this
    @State private var gymLongitude: String = "" // Add this
    @State private var favoriteGyms: [GymLocation] = []

    @AppStorage("favoriteGyms") private var favoriteGymsData: Data = Data()

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Enter Gym Name")) {
                    TextField("Gym Name", text: $gymName)
                    TextField("Latitude", text: $gymLatitude).keyboardType(.decimalPad) // Add this
                    TextField("Longitude", text: $gymLongitude).keyboardType(.decimalPad) // Add this
                }

                if !favoriteGyms.isEmpty {
                    Section(header: Text("Favorites")) {
                        ForEach(favoriteGyms) { gym in // Use default Identifiable conformance
                            Button(action: {
                                selectedGym = gym // gym is now a GymLocation
                                dismiss()
                            }) {
                                Text(gym.name) // Display gym's name
                            }
                        }
                        .onDelete(perform: deleteFavorite)
                    }
                }

                Section {
                    Button("Save") {
                        saveGym()
                    }
                    .disabled(gymName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .navigationTitle("Select Gym")
            .toolbar {
                EditButton()
            }
            .onAppear {
                loadFavorites()
            }
        }
    }

    private func loadFavorites() {
        if let decoded = try? JSONDecoder().decode([GymLocation].self, from: favoriteGymsData) { // Decode [GymLocation]
            favoriteGyms = decoded
        }
    }

    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favoriteGyms) { // Encode [GymLocation]
            favoriteGymsData = encoded
        }
    }

    private func saveGym() {
        let trimmedName = gymName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        let lat = Double(gymLatitude) ?? 0.0 // Parse latitude
        let lon = Double(gymLongitude) ?? 0.0 // Parse longitude
        let newGym = GymLocation(name: trimmedName, latitude: lat, longitude: lon) // Use parsed coordinates

        if !favoriteGyms.contains(where: { $0.name == newGym.name }) { // Check for existence by name
            favoriteGyms.append(newGym) // Append GymLocation instance
            saveFavorites()
        }

        selectedGym = newGym // Assign the new GymLocation instance

        // Clear input fields
        gymName = ""
        gymLatitude = ""
        gymLongitude = ""

        dismiss()
    }

    private func deleteFavorite(at offsets: IndexSet) {
        favoriteGyms.remove(atOffsets: offsets)
        saveFavorites()
    }
}
