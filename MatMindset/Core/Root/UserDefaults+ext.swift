//
//  UserDefaults+ext.swift
//  MatMindset
//
//  Created by Mark Martin on 5/30/25.
//

import Foundation

extension UserDefaults {
    private struct Keys {
        static let showTabbarView = "showTabbarView"
    }
    
    static var showTabbarView: Bool {
        get {
            standard.bool(forKey: Keys.showTabbarView)
        }
        
        set {
            standard.set(newValue, forKey: Keys.showTabbarView)
        }
    }
}
