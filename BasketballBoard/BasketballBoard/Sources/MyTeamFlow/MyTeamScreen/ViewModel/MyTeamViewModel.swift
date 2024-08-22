//
//  MyTeamViewModel.swift
//  BasketballBoard
//
//  Created by Eva on 03.06.2024.
//

import Foundation
import Combine

//protocol MyTeamViewModelProtocol {
//    var myTeams: [Team] { get }
//    
//    func addNewPlayer()
//    func removePlayer(by index: Int)
//    func addNewTeam(name: String)
//    func editTeam()
//}

final class MyTeamViewModel: ObservableObject {
    
    //MARK: - Properties
    @Published var myTeams: [Team] = []
    @Published var createNewTeamPressed = false
    @Published var createNewPlayerPressed = false
    
    var currentTeam: Team? {
        myTeams.first
    }
    var currentTeamPlayers: [Player]?
    var playerToDelete: Player?
    
    var shouldShowMessage = false
    
    var startingPlayers: [Player] {
        currentTeamPlayers?.filter { $0.isStartingPlayer }
            .sorted{ $0.position.rawValue < $1.position.rawValue } ?? []
    }
    
    var benchPlayers: [Player] {
        currentTeamPlayers?.filter { !$0.isStartingPlayer }
            .sorted{ $0.position.rawValue < $1.position.rawValue } ?? []
    }
    
    var isEnableAddPlayersToStart: Bool {
        startingPlayers.count < 5
    }
    
    //MARK: - Init
    init() {
        myTeams = fetchTeams()
        currentTeamPlayers = currentTeam?.players ?? []
    }
    
    //MARK: - Protocol methods
    func updateCurrentTeam(_ team: Team) {
        currentTeamPlayers = team.players
    }
    
    func removePlayer(player: Player?) {
        guard let indexToRemove = currentTeam?.players.firstIndex(where: {$0 == player}) else { return }
        guard let indexOfTeam = myTeams.firstIndex(where: {$0 == currentTeam}) else { return }
        
        currentTeamPlayers?.remove(at: indexToRemove)
        myTeams[indexOfTeam].players.remove(at: indexToRemove)
    }
    
    func setPlayerToDelete(_ player: Player?) {
        playerToDelete = player
    }
    
    func movePlayerToOrFromBench(_ player: Player) {
        guard let indexToMove = currentTeam?.players.firstIndex(where: {$0 == player}),
              let indexOfTeam = myTeams.firstIndex(where: {$0 == currentTeam}) else { return }
        
        if player.isStartingPlayer {
            currentTeamPlayers?[indexToMove].isStartingPlayer.toggle()
            myTeams[indexOfTeam].players[indexToMove].isStartingPlayer.toggle()
        } else {
            guard isEnableAddPlayersToStart else {
                shouldShowMessage = true
                return
            }
            currentTeamPlayers?[indexToMove].isStartingPlayer.toggle()
            myTeams[indexOfTeam].players[indexToMove].isStartingPlayer.toggle()
        }
    }
    
    func addNewTeam(name: String, imageData: Data? = nil) {
        let newTeam = Team(name: name, teamPhotoData: imageData)
        myTeams.append(newTeam)
    }
    
    func addNewPlayer(_ player: Player?) {
        guard let player else { return }
    }
    
    func editTeam() {
        
    }
}

//MARK: - Private methods
private extension MyTeamViewModel {
    func fetchTeams() -> [Team] {
        
        return []
    }
}
