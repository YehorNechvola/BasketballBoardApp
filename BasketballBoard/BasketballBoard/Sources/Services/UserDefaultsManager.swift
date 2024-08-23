//
//  UserDefaultsManager.swift
//  BasketballBoard
//
//  Created by Eva on 23.08.2024.
//

import Foundation

final class UserDefaultsManager {
    
    private enum Keys {
       static var currentTeamIdKey: String { "currentTeamIdKey" }
    }
    
    static let shared = UserDefaultsManager()
    private let userDefaults = UserDefaults.standard
    
    private init () { }
    
    var currentTeamId: String? {
        get {
            userDefaults.string(forKey: Keys.currentTeamIdKey)
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.currentTeamIdKey)
        }
    }
}
