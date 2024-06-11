//
//  MyTeamViewModel.swift
//  BasketballBoard
//
//  Created by Eva on 03.06.2024.
//

import Foundation

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
    var currentTeam: Team?
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
        currentTeam = myTeams.first
        currentTeamPlayers = currentTeam?.players ?? []
    }
    
    //MARK: - Protocol methods
    func updateCurrentTeam(_ team: Team) {
        currentTeam = team
        currentTeamPlayers = team.players
    }
    
    func removePlayer(player: Player?) {
        guard let indexToRemove = currentTeam?.players.firstIndex(where: {$0 == player}) else { return }
        guard let indexOfTeam = myTeams.firstIndex(where: {$0 == currentTeam}) else { return }
        
        currentTeamPlayers?.remove(at: indexToRemove)
        currentTeam?.players.remove(at: indexToRemove)
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
            currentTeam?.players[indexToMove].isStartingPlayer.toggle()
            myTeams[indexOfTeam].players[indexToMove].isStartingPlayer.toggle()
        } else {
            guard isEnableAddPlayersToStart else {
                shouldShowMessage = true
                return
            }
            currentTeamPlayers?[indexToMove].isStartingPlayer.toggle()
            currentTeam?.players[indexToMove].isStartingPlayer.toggle()
            myTeams[indexOfTeam].players[indexToMove].isStartingPlayer.toggle()
        }
    }
    
    func addNewPlayer() { }
    func addNewTeam(name: String) { }
    func editTeam() { }
}


//MARK: - Private methods
private extension MyTeamViewModel {
    func fetchTeams() -> [Team] {
        let testPlayer1 = Player(name: "Kobe", surname: "Bryant", team: nil, position: .shootingGuard, photoData: nil, birthDate: nil, notes: "Black mamba")
        let testPlayer2 = Player(name: "Derrick", surname: "Rose", team: nil, position: .pointGuard, photoData: nil, birthDate: nil, notes: "Rose")
        let testPlayer3 = Player(name: "Lebron", surname: "James", team: nil, position: .smallForward, photoData: nil, birthDate: nil, notes: "King James")
        let testPlayer4 = Player(name: "Carloz", surname: "Buzzer", team: nil, position: .powerForward, photoData: nil, birthDate: nil, notes: "Buzz")
        let testPlayer5 = Player(name: "Shaq", surname: "Oneel", team: nil, position: .center, photoData: nil, birthDate: nil, notes: "Black mamba")
        
        let testPlayer6 = Player(name: "Stephen", surname: "Curry", isStartingPlayer: false, team: nil, position: .pointGuard, photoData: nil, birthDate: nil, notes: "Cheff")
        let testPlayer7 = Player(name: "Anthony", surname: "Edvards", isStartingPlayer: false, team: nil, position: .shootingGuard, photoData: nil, birthDate: nil, notes: "Son of Jordan")
        let testPlayer8 = Player(name: "Michael", surname: "Jordan", isStartingPlayer: false, team: nil, position: .shootingGuard, photoData: nil, birthDate: nil, notes: "GOAT")
        let testPlayer9 = Player(name: "Bam", surname: "Adebayo", isStartingPlayer: false, team: nil, position: .powerForward, photoData: nil, birthDate: nil, notes: "Bam Wham!")
        let testPlayer10 = Player(name: "Nicola", surname: "Jokic", isStartingPlayer: false, team: nil, position: .center, photoData: nil, birthDate: nil, notes: "Jocker")
       
        let players1 = [testPlayer1,  testPlayer2, testPlayer3, testPlayer4, testPlayer5]
        let players2 = [testPlayer6, testPlayer7, testPlayer8, testPlayer9, testPlayer10]
        
//        var team1 = Team(name: "First team", players: players1)
//        var team2 = Team(name: "Second", players: players2)
//        let team3 = Team(name: "Third team")
        let team4 = Team(name: "Four team", players: players1 + players2)
//        let team5 = Team(name: "Five team")
//        var team6 = Team(name: "Six team", players: players2 + players1)
//        var team7 = Team(name: "Seven team")
//        let team8 = Team(name: "Eight team")
//        let team9 = Team(name: "Nine team")
//        let team10 = Team(name: "Ten team")
//        let team11 = Team(name: "Eleven team")
//        let team12 = Team(name: "Twelve team")
//        let team13 = Team(name: "Thirtenn team")
        
        return [team4]
    }
}
