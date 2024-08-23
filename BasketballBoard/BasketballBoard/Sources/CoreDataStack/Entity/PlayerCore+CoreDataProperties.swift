//
//  PlayerCore+CoreDataProperties.swift
//  BasketballBoard
//
//  Created by Eva on 22.08.2024.
//
//

import Foundation
import CoreData


extension PlayerCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlayerCore> {
        return NSFetchRequest<PlayerCore>(entityName: "PlayerCore")
    }

    @NSManaged public var name: String?
    @NSManaged public var surname: String?
    @NSManaged public var birthDay: Date?
    @NSManaged public var position: String?
    @NSManaged public var number: Int16
    @NSManaged public var notes: String?
    @NSManaged public var photo: Data?
    @NSManaged public var team: TeamCore?

}

extension PlayerCore : Identifiable {

}
