//
//  MyTeamViewModel.swift
//  BasketballBoard
//
//  Created by Eva on 03.06.2024.
//

import Foundation
import Combine


final class MyTeamViewModel: ObservableObject {
    
    //MARK: - Properties
    private let storeManager: CoreDataStackManager = .shared
    private let userDefaultsManager: UserDefaultsManager = .shared
    
    @Published var myTeams: [TeamCore] = []
    @Published var createNewTeamPressed = false
    @Published var createNewPlayerPressed = false
    @Published var shouldShowMessage = false
    
    var currentTeam: TeamCore? {
        myTeams.first { $0.id == userDefaultsManager.currentTeamId }
    }
    
    var teamsCount: Int { myTeams.count }
    var playerToDelete: PlayerCore?
    
    var startingPlayers: [PlayerCore] {
        let playersArray: [PlayerCore] = (currentTeam?.players?.allObjects ?? []) as! [PlayerCore]
        
        return playersArray.filter { $0.isStartingPlayer }.sorted { $0.additionNumber < $1.additionNumber }
    }
    
    var benchPlayers: [PlayerCore] {
        let playersArray: [PlayerCore] = (currentTeam?.players?.allObjects ?? []) as! [PlayerCore]
        
        return playersArray.filter { !$0.isStartingPlayer }.sorted { $0.additionNumber < $1.additionNumber }
    }
    
    //MARK: - Init
    init() {
        myTeams = storeManager.fetchAllTeams()
    }
    
    //MARK: - Protocol methods
    func updateCurrentTeam(_ team: Team) {

    }
    
    func removePlayer(player: PlayerCore?) {
        guard let currentTeam,
              let player else {
            return
        }
        
        storeManager.deletePlayer(from: currentTeam, playerToDelete: player)
        myTeams = storeManager.fetchAllTeams()
    }
    
    func setPlayerToDelete(_ player: PlayerCore?) {
        playerToDelete = player
    }
    
    func movePlayerToOrFromBench(_ player: PlayerCore) {
        if player.isStartingPlayer || startingPlayers.count < 5 {
            storeManager.updatePlayerStarting(player)
            myTeams = storeManager.fetchAllTeams()
        }
    }
    
    func handleStartingLineupMessage(_ player: PlayerCore) {
        guard startingPlayers.count > 4,
              !player.isStartingPlayer else { return }
        shouldShowMessage = true
    }
    
    func addNewTeam(name: String, imageData: Data? = nil) {
        userDefaultsManager.currentTeamId = storeManager.createTeam(name: name, photoData: imageData)
        myTeams = storeManager.fetchAllTeams()
    }
    
    func addNewPlayer(_ player: Player?) {
        guard let player,
              let currentTeam else {
            return
        }
        
        storeManager.addPlayer(to: currentTeam, playerEntity: player)
        myTeams = storeManager.fetchAllTeams()
    }
    
    func editTeam() {
        
    }
}

//MARK: - Private methods
private extension MyTeamViewModel {
    
}
