//
//  LocationManager.swift
//  MatMindset
//
//  Created by Mark Martin on 5/31/25.
//

import CoreLocation
import SwiftUI

@Observable @MainActor
final class LocationManager: NSObject, Sendable {
    private let locationManager = CLLocationManager()
    
    var currentLocation: CLLocation?
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    var locationError: Error?
    private let geocoder = CLGeocoder()
    @MainActor var currentLocationName: String?
    
    // MARK: - Private Properties
    // private var gymLocation: CLLocation? // Removed
    var isAtGym = false
    // private var allowedRadius: Double = 100 // meters // Removed

    @AppStorage("favoriteGyms") private var favoriteGymsData: Data = Data() // Added
    private var favoritedGyms: [GymLocation] { // Added
        if let decoded = try? JSONDecoder().decode([GymLocation].self, from: favoriteGymsData) {
            return decoded
        }
        return []
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        print("LocationManager initialized with \(favoritedGyms.count) favorite gyms.") // Added log
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func isUserWithinRegion(target: CLLocationCoordinate2D, radiusInMeters: Double) -> Bool {
        guard let userLocation = currentLocation else { return false }
        let targetLocation = CLLocation(latitude: target.latitude, longitude: target.longitude)
        let distance = userLocation.distance(from: targetLocation)
        return distance <= radiusInMeters
    }
    
    // Removed setGymLocation function
    
    /// Returns true if the user is within range of any favorited gym
    func checkProximityToFavoritedGyms(radiusInMeters: Double = 100) -> Bool { // Renamed and updated
        guard let userLocation = currentLocation else { return false }
        guard !favoritedGyms.isEmpty else { return false }

        for gym in favoritedGyms {
            let gymCLLocation = CLLocation(latitude: gym.latitude, longitude: gym.longitude)
            let distance = userLocation.distance(from: gymCLLocation)
            if distance <= radiusInMeters {
                return true // User is near at least one favorited gym
            }
        }
        return false // User is not near any favorited gym
    }
    
    func getCurrentLocation() async throws -> CLLocation {
        try await withCheckedThrowingContinuation { continuation in
            locationManager.requestLocation()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                if let location = self.currentLocation {
                    continuation.resume(returning: location)
                } else if let error = self.locationError {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: NSError(domain: "LocationError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Location not available"]))
                }
            }
        }
    }
    
    func fetchLocationName(for coordinate: CLLocationCoordinate2D) {
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
                guard let self else { return }
                if let error = error {
                    print("❌ Reverse geocoding failed: \(error.localizedDescription)")
                    return
                }

                if let placemark = placemarks?.first {
                    let name = placemark.name ?? placemark.locality ?? placemark.administrativeArea
                    DispatchQueue.main.async {
                        self.currentLocationName = name
                        print("📍 Location name: \(name ?? "Unknown")")
                    }
                }
            }
        }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.authorizationStatus = status
        }
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return } // Removed gymLocation check
        
        self.currentLocation = userLocation
        // Updated isAtGym logic
        isAtGym = checkProximityToFavoritedGyms(radiusInMeters: 50) // Using 50 meters as the threshold

        print("📍 Current location: \(currentLocation?.coordinate.latitude ?? 0), \(currentLocation?.coordinate.longitude ?? 0)")
        print("📍 isAtGym: \(isAtGym)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.locationError = error
        }
    }
}


