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
    private var gymLocation: CLLocation?
    var isAtGym = false

    private var allowedRadius: Double = 100 // meters
    
    override init() {
        super.init()
        locationManager.delegate = self
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
    
    /// Set the gym location to compare against
    func setGymLocation(latitude: Double, longitude: Double, radius: Double = 100) {
        self.gymLocation = CLLocation(latitude: latitude, longitude: longitude)
        self.allowedRadius = radius
    }
    
    /// Returns true if the user is within range of the gym
    func checkProximityToGym() -> Bool {
        guard let current = currentLocation, let gym = gymLocation else { return false }
        let distance = current.distance(from: gym)
        let isWithinGymRegion = distance <= allowedRadius
        return isWithinGymRegion
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
        guard let userLocation = locations.last, let gym = gymLocation else { return }
        
        let distance = userLocation.distance(from: gym) // in meters
        self.currentLocation = userLocation

        isAtGym = distance <= 50 // threshold for "at gym" (50 meters)
        print("📍 Current location: \(currentLocation?.coordinate.latitude ?? 0), \(currentLocation?.coordinate.longitude ?? 0)")
        print("📍 isAtGym: \(isAtGym)")

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.locationError = error
        }
    }
}


