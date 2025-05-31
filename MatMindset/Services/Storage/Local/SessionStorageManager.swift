//
//  SessionStorageManager.swift
//  MatMindset
//
//  Created by Mark Martin on 5/30/25.
//

import Foundation

class SessionStorageManager {
    static let shared = SessionStorageManager()
    
    private let fileName = "sessions.json"
    
    private var fileURL: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName)
    }
    
    func saveSessions(_ sessions: [MMSessionModel]) {
        guard let url = fileURL else { return }
        do {
            let data = try JSONEncoder().encode(sessions)
            try data.write(to: url, options: [.atomicWrite])
        } catch {
            print("❌ Error saving sessions: \(error)")
        }
    }
    
    func loadSessions() -> [MMSessionModel] {
        guard let url = fileURL,
              let data = try? Data(contentsOf: url) else {
            return []
        }
        do {
            return try JSONDecoder().decode([MMSessionModel].self, from: data)
        } catch {
            print("❌ Error loading sessions: \(error)")
            return []
        }
    }
}
