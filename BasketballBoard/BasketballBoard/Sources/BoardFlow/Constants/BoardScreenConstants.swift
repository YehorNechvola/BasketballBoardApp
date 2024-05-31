//
//  BoardScreenConstants.swift
//  BasketballBoard
//
//  Created by Yehor on 29.05.2024.
//

import UIKit

enum AvailableDevices: String {
    case iPhone8 = "iPhone 8"
    case iPhone8Plus = "iPhone 8 Plus"
    case iPhoneSEThirdGeneration = "iPhone SE (3rd generation)"
    case otherDevices
}

enum BoardScreenConstants {
    
    static let bottomMargin: CGFloat = {
        var value: CGFloat = 0
        let device = UIDevice()
        let currentDevice = AvailableDevices(rawValue: device.name)
        
        switch currentDevice {
        case .iPhone8, .iPhone8Plus, .iPhoneSEThirdGeneration:
            value = 0
        default: value = 34
        }
        return value
    }()
    
    static let boardViewTopAnchor: CGFloat = UIScreen.main.bounds.height * 0.11
    static let boardHeight = UIScreen.main.bounds.height - 200  /*- (UserDefaults.standard.value(forKey: "tabBarHeight") as! CGFloat) - boardViewTopAnchor - bottomMargin*/
    static let boardWidth = UIScreen.main.bounds.width
    static var playerWidth: CGFloat = 30
    static var ballWidth: CGFloat = 25
    
    static let pointFirstPlayer = CGPoint(x: boardWidth * 0.5, y: boardViewTopAnchor + boardHeight * 0.4)
    static let pointSecondPlayer = CGPoint(x: boardWidth * 0.85, y: boardViewTopAnchor + boardHeight * 0.25)
    static let pointThirdPlayer = CGPoint(x: boardWidth * 0.15, y: boardViewTopAnchor + boardHeight * 0.25)
    static let pointFourthPlayer = CGPoint(x: boardWidth * 0.85, y: boardViewTopAnchor + boardHeight * 0.08)
    static let pointFifthPlayer = CGPoint(x: boardWidth * 0.15, y: boardViewTopAnchor + boardHeight * 0.08)
    static let attackingPlayersCoordinates = [pointFirstPlayer,
                                              pointSecondPlayer,
                                              pointThirdPlayer,
                                              pointFourthPlayer,
                                              pointFifthPlayer]
    
    static let pointFirstDefender = CGPoint(x: boardWidth * 0.5, y: boardViewTopAnchor + boardHeight * 0.325)
    static let pointSecondDefender = CGPoint(x: boardWidth * 0.85 - 35, y: boardViewTopAnchor + boardHeight * 0.22)
    static let pointThirdDefender = CGPoint(x: boardWidth * 0.15 + 35, y: boardViewTopAnchor + boardHeight * 0.22)
    static let pointFourthDefender = CGPoint(x: boardWidth * 0.85 - 35, y: boardViewTopAnchor + boardHeight * 0.08)
    static let pointFifthDefender = CGPoint(x: boardWidth * 0.15 + 35, y: boardViewTopAnchor + boardHeight * 0.08)
    static let defendingPlayersCoordinates = [pointFirstDefender,
                                              pointSecondDefender,
                                              pointThirdDefender,
                                              pointFourthDefender,
                                              pointFifthDefender]
    
    static let reversedPointFirstPlayer = CGPoint(x: boardWidth * 0.5, y: boardViewTopAnchor + boardHeight * 0.6)
    static let reversedPointSecondPlayer = CGPoint(x: boardWidth * 0.15, y: boardViewTopAnchor + boardHeight * 0.75)
    static let reversedPointThirdPlayer = CGPoint(x: boardWidth * 0.85, y: boardViewTopAnchor + boardHeight * 0.75)
    static let reversedPointFourthPlayer = CGPoint(x: boardWidth * 0.15, y: boardViewTopAnchor + boardHeight * 0.92)
    static let reversedPointFifthPlayer = CGPoint(x: boardWidth * 0.85, y: boardViewTopAnchor + boardHeight * 0.92)
    static let reversedAttackingPlayersCoordinates = [reversedPointFirstPlayer,
                                                      reversedPointSecondPlayer,
                                                      reversedPointThirdPlayer,
                                                      reversedPointFourthPlayer,
                                                      reversedPointFifthPlayer]
    
    static let reversedPointFirstDefender = CGPoint(x: boardWidth * 0.5, y: boardViewTopAnchor + boardHeight * 0.675)
    static let reversedPointSecondDefender = CGPoint(x: boardWidth * 0.15 + 35, y: boardViewTopAnchor + boardHeight * 0.78)
    static let reversedPointThirdDefender = CGPoint(x: boardWidth * 0.85 - 35, y: boardViewTopAnchor + boardHeight * 0.78)
    static let reversedPointFourthDefender = CGPoint(x: boardWidth * 0.15 + 35, y: boardViewTopAnchor + boardHeight * 0.92)
    static let reversedPointFifthDefender = CGPoint(x: boardWidth * 0.85 - 35, y: boardViewTopAnchor + boardHeight * 0.92)
    static let reversedDefendingPlayersCoordinates = [reversedPointFirstDefender,
                                                      reversedPointSecondDefender,
                                                      reversedPointThirdDefender,
                                                      reversedPointFourthDefender,
                                                      reversedPointFifthDefender]
    
    
    static let pointBallImageView = CGPoint(x: pointFirstPlayer.x + 13, y: pointFirstPlayer.y - 15)
    static let reversedBallImageView = CGPoint(x: reversedPointFirstPlayer.x - 13, y: reversedPointFirstPlayer.y + 15)
    
    static let pointOfBasket = CGPoint(x:  boardWidth * 0.5, y: boardViewTopAnchor + boardHeight * 0.089)
    static let reversedPointOfBasket = CGPoint(x:  boardWidth * 0.5, y: boardViewTopAnchor + boardHeight * 0.911)
}

enum BoardScreenImages {
    static let boardImage = UIImage(named: "board")
    static let ballImage = UIImage(named: "ball")
}
