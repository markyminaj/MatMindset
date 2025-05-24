//
//  MMSessionModel.swift
//  MatMindset
//
//  Created by Mark Martin on 5/23/25.
//

import Foundation

struct MMSessionModel: Hashable {
    let sessionID: String
    let sessionDate: Date?
    let sessionDuration: TimeInterval?
    let sessionNotes: String?
    let techniques: String?
    
    init(sessionID: String, sessionDate: Date?, sessionDuration: TimeInterval?, sessionNotes: String?, techniques: String?) {
        self.sessionID = sessionID
        self.sessionDate = sessionDate
        self.sessionDuration = sessionDuration
        self.sessionNotes = sessionNotes
        self.techniques = techniques
    }
    static var mock: MMSessionModel {
        mockSessions[0]
    }
    
    static var mockSessions: [MMSessionModel] = [
        MMSessionModel(
            sessionID: UUID().uuidString,
            sessionDate: Calendar.current.date(byAdding: .day, value: 0, to: Date()),
            sessionDuration: 90 * 60,
            sessionNotes: "Great session today! Focused on pressure passing and sparring from top position. Managed to hold side control longer and set up some submissions.",
            techniques: "Pressure Passing, Side Control Retention, Americana"
        ),
        MMSessionModel(
            sessionID: UUID().uuidString,
            sessionDate: Calendar.current.date(byAdding: .day, value: -1, to: Date()),
            sessionDuration: 75 * 60,
            sessionNotes: "Worked on takedowns and transitions to mount. Felt more confident with single-leg entries.",
            techniques: "Single Leg Takedown, Mount Transition, Cross Collar Choke"
        ),
        MMSessionModel(
            sessionID: UUID().uuidString,
            sessionDate: Calendar.current.date(byAdding: .day, value: -3, to: Date()),
            sessionDuration: 60 * 60,
            sessionNotes: "Drilled butterfly sweeps and did situational sparring from half guard. Struggled with frames under pressure.",
            techniques: "Butterfly Sweep, Half Guard Framing, Underhook Recovery"
        ),
        MMSessionModel(
            sessionID: UUID().uuidString,
            sessionDate: Calendar.current.date(byAdding: .day, value: -5, to: Date()),
            sessionDuration: 80 * 60,
            sessionNotes: "Open mat session. Rolled with four different partners, tried to focus on flow and movement.",
            techniques: "Open Mat Sparring, Flow Rolling, Guard Recovery"
        ),
        MMSessionModel(
            sessionID: UUID().uuidString,
            sessionDate: Calendar.current.date(byAdding: .day, value: -7, to: Date()),
            sessionDuration: 90 * 60,
            sessionNotes: "Class on back attacks. Learned to control the seatbelt grip and transition to bow and arrow choke.",
            techniques: "Back Control, Seatbelt Grip, Bow and Arrow Choke"
        )
    ]
}
