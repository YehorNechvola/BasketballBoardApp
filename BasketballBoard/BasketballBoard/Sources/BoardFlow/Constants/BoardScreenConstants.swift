//
//  BoardScreenConstants.swift
//  BasketballBoard
//
//  Created by Yehor on 29.05.2024.
//

import UIKit
enum BoardScreenPointer {
    
    static var playerWidth: CGFloat = 30
    static var ballWidth: CGFloat = 25
    
    static func getPlayerCoordinates(frame: CGRect,
                                     type: BasketBoardInstaller.TypeOfPlayer,
                                     side: BasketBoardInstaller.SideOfCourt) -> [CGPoint] {
        
        let pointFirstPlayer: CGPoint
        let pointSecondPlayer: CGPoint
        let pointThirdPlayer: CGPoint
        let pointFourthPlayer: CGPoint
        let pointFifthPlayer: CGPoint
        
        switch type {
        case .attacking:
            
            switch side {
            case .home:
                pointFirstPlayer = CGPoint(x: frame.width * 0.5 + frame.minX, y: frame.height * 0.4 + frame.minY)
                pointSecondPlayer = CGPoint(x: frame.width * 0.85 + frame.minX, y: frame.height * 0.25 + frame.minY)
                pointThirdPlayer = CGPoint(x: frame.width * 0.15 + frame.minX, y: frame.height * 0.25 + frame.minY)
                pointFourthPlayer = CGPoint(x: frame.width * 0.85 + frame.minX, y: frame.height * 0.08 + frame.minY)
                pointFifthPlayer = CGPoint(x: frame.width * 0.15 + frame.minX, y: frame.height * 0.08 + frame.minY)
            case .away:
                pointFirstPlayer = CGPoint(x: frame.width * 0.5 + frame.minX, y: frame.height * 0.6 + frame.minY)
                pointSecondPlayer = CGPoint(x: frame.width * 0.15 + frame.minX, y: frame.height * 0.75 + frame.minY)
                pointThirdPlayer = CGPoint(x: frame.width * 0.85 + frame.minX, y: frame.height * 0.75 + frame.minY)
                pointFourthPlayer = CGPoint(x: frame.width * 0.15 + frame.minX, y: frame.height * 0.92 + frame.minY)
                pointFifthPlayer = CGPoint(x: frame.width * 0.85 + frame.minX, y: frame.height * 0.92 + frame.minY)
            }
            
        case .defending:
            
            switch side {
            case .home:
                pointFirstPlayer = CGPoint(x: frame.width * 0.5 + frame.minX, y: frame.height * 0.325 + frame.minY)
                pointSecondPlayer = CGPoint(x: frame.width * 0.85 + frame.minX - 35, y: frame.height * 0.22 + frame.minY)
                pointThirdPlayer = CGPoint(x: frame.width * 0.15 + frame.minX + 35, y: frame.height * 0.22 + frame.minY)
                pointFourthPlayer = CGPoint(x: frame.width * 0.85 + frame.minX - 35, y: frame.height * 0.08 + frame.minY)
                pointFifthPlayer = CGPoint(x: frame.width * 0.15 + frame.minX + 35, y: frame.height * 0.08 + frame.minY)
                
            case .away:
                pointFirstPlayer = CGPoint(x: frame.width * 0.5 + frame.minX, y: frame.height * 0.675 + frame.minY)
                pointSecondPlayer = CGPoint(x: frame.width * 0.15 + frame.minX + 35, y: frame.height * 0.78 + frame.minY)
                pointThirdPlayer = CGPoint(x: frame.width * 0.85 + frame.minX - 35, y: frame.height * 0.78 + frame.minY)
                pointFourthPlayer = CGPoint(x: frame.width * 0.15 + frame.minX + 35, y: frame.height * 0.92 + frame.minY)
                pointFifthPlayer = CGPoint(x: frame.width * 0.85 + frame.minX - 35, y: frame.height * 0.92 + frame.minY)
            }
        }
        
        return [pointFirstPlayer,
                pointSecondPlayer,
                pointThirdPlayer,
                pointFourthPlayer,
                pointFifthPlayer]
    }
    
    static func getBallCenterPoint(frame: CGRect, side: BasketBoardInstaller.SideOfCourt) -> CGPoint {
        switch side {
        case .home:
            return CGPoint(x: frame.width * 0.5 + frame.minX + 13, y: frame.height * 0.4 + frame.minY - 15)
        case .away:
            return CGPoint(x: frame.width * 0.5 + frame.minX - 13, y: frame.height * 0.6 + frame.minY + 15)
        }
    }
    
    static func getBasketCenterPoint(frame: CGRect, side: BasketBoardInstaller.SideOfCourt) -> CGPoint {
        switch side {
        case .home:
            return CGPoint(x: frame.width * 0.5 + frame.minX, y: frame.height * 0.089 + frame.minY)
        case .away:
            return CGPoint(x: frame.width * 0.5 + frame.minX, y: frame.height * 0.911 + frame.minY)
        }
    }
}

enum BoardScreenImages {
    static let boardImage = UIImage(named: "board")
    static let ballImage = UIImage(named: "ball")
}
