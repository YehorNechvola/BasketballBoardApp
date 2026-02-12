//
//  TeamCore.swift
//  BasketballBoard
//
//  Created by Rush_user on 11.02.2026.
//

import Foundation
import SwiftData

@Model
final class TeamCore {
    @Attribute(.unique) var id: String
    var name: String
    var photo: Data?
    
    @Relationship(deleteRule: .cascade)
    var players: [PlayerCore] = []
    
    init(id: String, name: String, photo: Data?) {
        self.id = id
        self.name = name
        self.photo = photo
    }
}
