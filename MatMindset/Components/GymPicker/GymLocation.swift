//
//  GymLocation.swift
//  MatMindset
//
//  Created by Mark Martin on 5/30/25.
//

import SwiftUI

struct GymLocation: Codable, Equatable {
    var name: String
}

struct SimpleGymPickerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedGym: GymLocation?

    @State private var gymName: String = ""
    @State private var favoriteGyms: [String] = []

    @AppStorage("favoriteGyms") private var favoriteGymsData: Data = Data()

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Enter Gym Name")) {
                    TextField("Gym Name", text: $gymName)
                }

                if !favoriteGyms.isEmpty {
                    Section(header: Text("Favorites")) {
                        ForEach(favoriteGyms, id: \.self) { gym in
                            Button(action: {
                                selectedGym = GymLocation(name: gym)
                                dismiss()
                            }) {
                                Text(gym)
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
        if let decoded = try? JSONDecoder().decode([String].self, from: favoriteGymsData) {
            favoriteGyms = decoded
        }
    }

    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favoriteGyms) {
            favoriteGymsData = encoded
        }
    }

    private func saveGym() {
        let trimmedName = gymName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        if !favoriteGyms.contains(trimmedName) {
            favoriteGyms.append(trimmedName)
            saveFavorites()
        }

        selectedGym = GymLocation(name: trimmedName)
        dismiss()
    }

    private func deleteFavorite(at offsets: IndexSet) {
        favoriteGyms.remove(atOffsets: offsets)
        saveFavorites()
    }
}
