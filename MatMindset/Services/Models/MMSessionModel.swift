//
//  MMSessionModel.swift
//  MatMindset
//
//  Created by Mark Martin on 5/23/25.
//

import Foundation
import CoreLocation

struct MMSessionModel: Identifiable, Hashable, Codable {
    let id: String
    let sessionDate: Date?
    let sessionDuration: Int?
    let sessionNotes: String?
    let sessionType: SessionType?
    let techniques: String?
    let location: String?
    
    // ✅ New additions
    let checkInPhotoFilename: String?
    let checkInLocationLatitude: Double?
    let checkInLocationLongitude: Double?
    
    init(
        id: String = UUID().uuidString,
        sessionDate: Date? = nil,
        sessionDuration: Int? = nil,
        sessionNotes: String? = nil,
        sessionType: SessionType? = nil,
        techniques: String? = nil,
        location: String? = nil,
        checkInPhotoFilename: String? = nil,
        checkInLocationLatitude: Double? = nil,
        checkInLocationLongitude: Double? = nil
    ) {
        self.id = id
        self.sessionDate = sessionDate
        self.sessionDuration = sessionDuration
        self.sessionNotes = sessionNotes
        self.sessionType = sessionType
        self.techniques = techniques
        self.location = location
        self.checkInPhotoFilename = checkInPhotoFilename
        self.checkInLocationLatitude = checkInLocationLatitude
        self.checkInLocationLongitude = checkInLocationLongitude
    }
    
    // MARK: - Computed Properties

    var checkInLocation: CLLocationCoordinate2D? {
        guard let lat = checkInLocationLatitude, let lon = checkInLocationLongitude else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }

    enum SessionType: String, CaseIterable, Codable, Identifiable {
        case gi = "Gi"
        case noGi = "No-Gi"
        case openMat = "Open Mat"
        
        var id: String { self.rawValue }
    }

//    static var mock: MMSessionModel {
//        mockSessions[0]
//    }
//    
//    static var mockSessions: [MMSessionModel] = [
//        MMSessionModel(
//            id: UUID().uuidString,
//            sessionDate: Calendar.current.date(byAdding: .day, value: 0, to: Date()),
//            sessionDuration: 60,
//            sessionNotes: "Great session today! Focused on pressure passing and sparring from top position. Managed to hold side control longer and set up some submissions.", sessionType: .gi,
//            techniques: "Pressure Passing, Side Control Retention, Americana",
//            location: "National City Jiujitsu Club"
//
//        ),
//        MMSessionModel(
//            id: UUID().uuidString,
//            sessionDate: Calendar.current.date(byAdding: .day, value: -1, to: Date()),
//            sessionDuration: 75,
//            sessionNotes: "Worked on takedowns and transitions to mount. Felt more confident with single-leg entries.", sessionType: .noGi,
//            techniques: "Single Leg Takedown, Mount Transition, Cross Collar Choke",
//            location: "National City Jiujitsu Club"
//
//        ),
//        MMSessionModel(
//            id: UUID().uuidString,
//            sessionDate: Calendar.current.date(byAdding: .day, value: -3, to: Date()),
//            sessionDuration: 60,
//            sessionNotes: "Drilled butterfly sweeps and did situational sparring from half guard. Struggled with frames under pressure.", sessionType: .openMat,
//            techniques: "Butterfly Sweep, Half Guard Framing, Underhook Recovery",
//            location: "National City Jiujitsu Club"
//
//        ),
//        MMSessionModel(
//            id: UUID().uuidString,
//            sessionDate: Calendar.current.date(byAdding: .day, value: -5, to: Date()),
//            sessionDuration: 80,
//            sessionNotes: "Open mat session. Rolled with four different partners, tried to focus on flow and movement.", sessionType: .openMat,
//            techniques: "Open Mat Sparring, Flow Rolling, Guard Recovery",
//            location: "National City Jiujitsu Club"
//
//        ),
//        MMSessionModel(
//            id: UUID().uuidString,
//            sessionDate: Calendar.current.date(byAdding: .day, value: -7, to: Date()),
//            sessionDuration: 90,
//            sessionNotes: "Class on back attacks. Learned to control the seatbelt grip and transition to bow and arrow choke.", sessionType: .noGi,
//            techniques: "Back Control, Seatbelt Grip, Bow and Arrow Choke",
//            location: "National City Jiujitsu Club"
//
//        )
//    ]
}
