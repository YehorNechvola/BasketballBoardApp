//
//  DataBaseManager.swift
//  BasketballBoard
//
//  Created by Rush_user on 11.02.2026.
//

import Foundation
import SwiftData

@MainActor
final class DataBaseManager {

    static let shared = DataBaseManager()
    
    let container: ModelContainer
    let context: ModelContext
    
    private init() {
        do {
            container = try ModelContainer(for: TeamCore.self, PlayerCore.self)
            context = container.mainContext
        } catch {
            fatalError("Failed to create container: \(error)")
        }
    }
    
    // MARK: - Save
    func save() {
        do {
            try context.save()
        } catch {
            print("Save error: \(error)")
        }
    }
    
    // MARK: - Fetch
    func fetchAllTeams() -> [TeamCore] {
        let descriptor = FetchDescriptor<TeamCore>()
        
        do {
            return try context.fetch(descriptor)
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }
    
    // MARK: - Create Team
    func createTeam(name: String, photoData: Data?) -> String {
        let id = UUID().uuidString
        
        let team = TeamCore(
            id: id,
            name: name
        )
        
        context.insert(team)
        save()
        
        return id
    }
    
    // MARK: - Add Player
    func addPlayer(to team: TeamCore, playerEntity: Player) {
        let startingCount = team.players.filter { $0.isStartingPlayer }.count
        let additionNumber = (team.players.map { $0.additionNumber }.max() ?? 0) + 1
        
        let player = PlayerCore(
            id: playerEntity.name + UUID().uuidString,
            name: playerEntity.name,
            surname: playerEntity.surname,
            birthDay: playerEntity.birthDate,
            notes: playerEntity.notes,
            isStartingPlayer: startingCount < 5,
            position: playerEntity.position.rawValue,
            number: playerEntity.playerNumber,
            additionNumber: additionNumber
        )
        
        team.players.append(player)
        
        context.insert(player)
        save()
    }
    
    // MARK: - Delete Player
    func deletePlayer(from team: TeamCore, player: PlayerCore) {
        if team.players.contains(where: { $0.id == player.id }) {
            context.delete(player)
            save()
        }
    }
    
    // MARK: - Toggle Starting
    func updatePlayerStarting(_ player: PlayerCore) {
        player.isStartingPlayer.toggle()
        save()
    }
}
