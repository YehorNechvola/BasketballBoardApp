//
//  CreatePlayerViewModel.swift
//  BasketballBoard
//
//  Created by Eva on 20.08.2024.
//

import Foundation
import Combine

final class CreatePlayerViewModel: ObservableObject {
    
    //MARK: - UI showing Properties
    @Published var shouldShowCropView = false
    @Published var shouldShowNumberPicker = false
    @Published var shouldAddSecondNumber = false
    @Published var shouldShowDatePicker = false
    
    //MARK: - Player Information
    @Published var selectedPosition: Player.PlayerPosition?
    var playerPositionText: String {
        guard let selectedPosition else {
            return "Position"
        }
        return selectedPosition.positionToString
    }
    @Published var selectedDate = Date()
    @Published var selectedDateToString: String?
    
    //MARK: - Input Fields
    @Published var nameInput: String?
    @Published var surnameInput: String?
    @Published var notesInput: String?
    var playePhotoData: Data?
    
    //MARK: - Player game number
    @Published var firstSelectedNumber = 0
    @Published var secondSelectedNumber = 0

    //MARK: - Computed Properties
    var numberPlayerToString: String {
        if  firstSelectedNumber == 0 {
            return "\(secondSelectedNumber)"
        }
        return "\(firstSelectedNumber)" + "\(secondSelectedNumber)"
    }
    
    var enableSavePlayer: Bool {
        if let nameInput,
           let surnameInput,
           let _ = selectedPosition,
           let _ = selectedDateToString,
           !nameInput.isEmpty,
           !surnameInput.isEmpty {
            return true
        }
        return false
    }
    
    //MARK: - Methods
    func createPlayer() -> Player? {
        guard let nameInput,
              let surnameInput,
              let selectedPosition,
              let _ = selectedDateToString,
           !nameInput.isEmpty,
           !surnameInput.isEmpty else {
            return nil
        }
        
       return Player(name: nameInput,
                     surname: surnameInput,
                     playerNumber: Int(numberPlayerToString) ?? 0,
                     position: selectedPosition,
                     photoData: playePhotoData,
                     birthDate: selectedDate,
                     notes: notesInput)
    }
    
    func atachPhotoData(data: Data?) {
        playePhotoData = data
    }
}

