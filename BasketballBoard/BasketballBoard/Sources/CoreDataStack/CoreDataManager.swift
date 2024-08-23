//
//  CoreDataManager.swift
//  BasketballBoard
//
//  Created by Eva on 22.08.2024.
//

import Foundation
import CoreData

final class CoreDataStackManager{
    
    static let shared = CoreDataStackManager()
    
    private init() { }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataStackModel")
        let description = NSPersistentStoreDescription()
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        container.persistentStoreDescriptions.append(description)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchAllTeams() -> [TeamCore] {
        let request: NSFetchRequest<TeamCore> = TeamCore.fetchRequest()
        
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Failed to fetch teams: \(error)")
            return []
        }
    }
    
    func createTeam(name: String, photoData: Data?) -> String {
        let newTeam = TeamCore(context: viewContext)
        newTeam.name = name
        newTeam.id = UUID().uuidString + name
        newTeam.photo = photoData
    
        saveContext()
        
        return newTeam.id
    }
    
    func addPlayer(to team: TeamCore, playerEntity: Player) {
        let player = PlayerCore(context: viewContext)
        player.name = playerEntity.name
        player.surname = playerEntity.surname
        player.birthDay = playerEntity.birthDate
        player.id = playerEntity.name + UUID().uuidString
        player.notes = playerEntity.notes
        player.photo = playerEntity.photoData
        
        
        let set = team.players?.allObjects as! [PlayerCore]
        let countOfStarting = set.filter { $0.isStartingPlayer }.count
        player.isStartingPlayer = countOfStarting < 5
        
        player.position = Int16(playerEntity.position.rawValue)
        player.number = playerEntity.playerNumber
        player.team = team
        player.additionNumber = team.players?.count ?? 0
        
        team.addToPlayers(player)  
        
        saveContext()
    }
    
    func deletePlayer(from team: TeamCore, playerToDelete: PlayerCore) {
        if let players = team.players as? Set<PlayerCore>, players.contains(playerToDelete) {
            team.removeFromPlayers(playerToDelete)
            viewContext.delete(playerToDelete)
            
            saveContext()
        } else {
            print("Player not found in the specified team.")
        }
    }
    
    func updatePlayerStarting(_ player: PlayerCore) {
        player.isStartingPlayer.toggle()
        saveContext()
    }
}

