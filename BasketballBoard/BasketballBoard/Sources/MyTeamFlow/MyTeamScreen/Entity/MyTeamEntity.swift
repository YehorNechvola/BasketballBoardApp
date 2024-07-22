//
//  MyTeamEntity.swift
//  BasketballBoard
//
//  Created by Eva on 03.06.2024.
//

import Foundation

struct Player: Equatable {
    
    enum PlayerPosition: Int, CaseIterable {
        case pointGuard = 1
        case shootingGuard
        case smallForward
        case powerForward
        case center
    }
    
    var name: String
    var surname: String
    var isStartingPlayer: Bool = true
    var team: Team?
    var position: PlayerPosition
    var photoData: Data?
    var birthDate: String?
    var notes: String?
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
