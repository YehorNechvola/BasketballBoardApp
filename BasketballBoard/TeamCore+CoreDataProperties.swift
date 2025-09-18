//
//  TeamCore+CoreDataProperties.swift
//  BasketballBoard
//
//  Created by Eva on 22.08.2024.
//
//

import Foundation
import CoreData


extension TeamCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TeamCore> {
        return NSFetchRequest<TeamCore>(entityName: "TeamCore")
    }

    @NSManaged public var name: String
    @NSManaged public var photo: Data?
    @NSManaged public var players: NSSet?
    @NSManaged public var id: String
}

// MARK: Generated accessors for players
extension TeamCore {

    @objc(addPlayersObject:)
    @NSManaged public func addToPlayers(_ value: PlayerCore)

    @objc(removePlayersObject:)
    @NSManaged public func removeFromPlayers(_ value: PlayerCore)

    @objc(addPlayers:)
    @NSManaged public func addToPlayers(_ values: NSSet)

    @objc(removePlayers:)
    @NSManaged public func removeFromPlayers(_ values: NSSet)

}

extension TeamCore : Identifiable {

}
