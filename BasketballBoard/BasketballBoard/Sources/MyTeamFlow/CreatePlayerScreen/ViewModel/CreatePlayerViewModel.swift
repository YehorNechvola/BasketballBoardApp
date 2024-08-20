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
    @Published var dateWasTapped = false
    
    //MARK: - Player Information
    @Published var selectedPosition = Player.PlayerPosition.pointGuard
    @Published var selectedDate = Date()
    @Published var selectedDateToString: String?
    
    //MARK: - Input Fields
    @Published var nameInput: String?
    @Published var surnameInput: String?
    @Published var notesInput: String?
    
    //MARK: - Player game number
    @Published var firstSelectedNumber = 0
    @Published var additionalNumber = 0

    //MARK: - Computed Properties
    var numberPlayerToString: String {
        let primaryNumber = "\(firstSelectedNumber)"
        let secondaryNumber = "\(additionalNumber)"
        
        if !shouldAddSecondNumber || firstSelectedNumber == 0 {
            return secondaryNumber
        }
        return primaryNumber + secondaryNumber
    }
}
