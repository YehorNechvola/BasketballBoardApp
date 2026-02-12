//
//  PlayerCore.swift
//  BasketballBoard
//
//  Created by Rush_user on 11.02.2026.
//

import SwiftData
import Foundation

@Model
final class PlayerCore {
    var id: String
    var name: String
    var surname: String
    var birthDay: Date
    var notes: String?
    var photo: Data?
    
    var isStartingPlayer: Bool
    var position: Int
    var number: Int
    var additionNumber: Int
    
    init(
        id: String,
        name: String,
        surname: String,
        birthDay: Date,
        notes: String?,
        photo: Data?,
        isStartingPlayer: Bool,
        position: Int,
        number: Int,
        additionNumber: Int
    ) {
        self.id = id
        self.name = name
        self.surname = surname
        self.birthDay = birthDay
        self.notes = notes
        self.photo = photo
        self.isStartingPlayer = isStartingPlayer
        self.position = position
        self.number = number
        self.additionNumber = additionNumber
    }
}

