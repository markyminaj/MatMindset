//
//  SessionManager.swift
//  MatMindset
//
//  Created by Mark Martin on 6/1/25.
//

import SwiftUI
import CoreLocation

@Observable
class SessionManager {
    var sessions: [MMSessionModel] = []
    var checkInPhoto: UIImage? = nil
    var checkInLocation: CLLocationCoordinate2D? = nil

    func addSession(session: MMSessionModel) {
        sessions.append(session)
    }

    func clearCheckInData() {
        checkInPhoto = nil
        checkInLocation = nil
    }
}
