//
//  BoardViewModel.swift
//  BasketballBoard
//
//  Created by Eva on 29.05.2024.
//

import Foundation

// MARK: - BoardViewModelProtocol

protocol BoardViewModelProtocol {
    var basketballBoardInstaller: BasketBoardInstallerProtocol { get set }
    
    func setBasketballBoardWithPlayers()
    func shootBall()
    func setPlayersToOriginPoints()
    func showOrHideDefenders()
    func changeSideOfCourt()
}

final class BoardViewModel: BoardViewModelProtocol {
    
    // MARK: - Properties
    
    var basketballBoardInstaller: BasketBoardInstallerProtocol
    
    // MARK: - Init
    
    init() {
        basketballBoardInstaller = BasketBoardInstaller()
    }
    
    // MARK: - Methods

    func setBasketballBoardWithPlayers() {
        basketballBoardInstaller.setupBoard()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.basketballBoardInstaller.addPlayer(type: .attacking, backgroundColor: .blue)
            self.basketballBoardInstaller.makeCollisionOnPlayersViews()
            self.basketballBoardInstaller.addBallView()
        }
    }
    
    func shootBall() {
        basketballBoardInstaller.shootBall()
    }
    
    func setPlayersToOriginPoints() {
        basketballBoardInstaller.setPlayersToOriginPoints()
    }
    
    func showOrHideDefenders() {
        basketballBoardInstaller.showOrHideDefenders()
    }
    
    func changeSideOfCourt() {
        basketballBoardInstaller.changeSideOfCourt()
    }
}
