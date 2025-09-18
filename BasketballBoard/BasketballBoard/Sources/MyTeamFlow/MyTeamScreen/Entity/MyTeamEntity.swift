//
//  MyTeamEntity.swift
//  BasketballBoard
//
//  Created by Eva on 03.06.2024.
//

import Foundation

struct Player: Equatable {
    
    enum PlayerPosition: Int, CaseIterable, Identifiable {
        var id: Self { self }
        
        case pointGuard = 1
        case shootingGuard
        case smallForward
        case powerForward
        case center
        
        var positionToString: String {
            switch self {
            case .pointGuard:
                "Point guard"
            case .shootingGuard:
                "Shooting guard"
            case .smallForward:
                "Small forward"
            case .powerForward:
                "Power forward"
            case .center:
                "Center"
            }
        }
    }
    
    var name: String
    var surname: String
    var playerNumber: Int16
    var position: PlayerPosition
    var photoData: Data?
    var birthDate: Date
    var notes: String?
    var isStartingPlayer = false
}

struct Team: Equatable, Identifiable {
    static func == (lhs: Team, rhs: Team) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: String { name }
    var name: String
    var teamPhotoData: Data?
    var players: [Player] = [Player]()
    
    mutating func removePlayer(_ player: Player) {
        guard let indexToRemove = players.firstIndex(of: player) else { return }
        var copy = players
        copy.remove(at: indexToRemove)
        players = copy
    }
}
