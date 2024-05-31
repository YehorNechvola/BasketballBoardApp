//
//  BoardInstaller.swift
//  BasketballBoard
//
//  Created by Yehor on 29.05.2024.
//

import UIKit

//MARK: - BasketBoardInstallerProtocol
protocol BasketBoardInstallerProtocol {
    var view: UIView? { get set }
    
    func setupBoard()
    func addPlayer(type: BasketBoardInstaller.TypeOfPlayer, backgroundColor: UIColor)
    func makeCollisionOnPlayersViews()
    func showOrHideDefenders()
    func addBallView()
    func setPlayersToOriginPoints()
    func shootBall()
    func changeSideOfCourt()
}

final class BasketBoardInstaller: BasketBoardInstallerProtocol {
    
    //MARK: - Enum helpers
    enum StateOfDefenders {
        case isHidden
        case isShowed
        case isHiding
    }
    
    enum TypeOfPlayer {
        case attacking
        case defending
    }
    
    enum SideOfCourt {
        case home
        case away
    }
    
    //MARK: - Properties
    var view: UIView?
    private var boardImageView: UIImageView!
    private var attackingPlayers = [PlayerView]()
    private var defendingPlayers = [PlayerView]()
    private var ballImageView: UIImageView!
    private var animator: UIDynamicAnimator!
    private var collisionBehavior: UICollisionBehavior!
    private var isIntersectBallWithPlayer = false
    private var isBallShooted = false
    private var isBallWithPlayer = false
    private var stateOfDefenders: StateOfDefenders = .isHidden
    private var sideOfCourt: SideOfCourt = .home
    private var rotationAngle: Double = 180
    private var xPointIdentFromBall: CGFloat = 0
    private var yPointIdentFromBall: CGFloat = 0
    
    // MARK: - Init
    
    init() { }
    
    //MARK: - Methods
    
    func setupBoard() {
        guard let view else { return }
        boardImageView = UIImageView()
        boardImageView.image = BoardScreenImages.boardImage
        boardImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(boardImageView)
        
        NSLayoutConstraint.activate([
            boardImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45),
            boardImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            boardImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            boardImageView.widthAnchor.constraint(equalTo: boardImageView.heightAnchor, multiplier: 0.622)
        ])
    }

     func addPlayer(type: TypeOfPlayer, backgroundColor: UIColor) {
         guard let view else { return }
         
        for item in 0...4 {
            let playerView = PlayerView()
            playerView.contentMode = .scaleAspectFill
            playerView.backgroundColor = backgroundColor
            playerView.dropShadow()
            playerView.frame = CGRect(x: 0, y: 0, width: BoardScreenPointer.playerWidth, height: BoardScreenPointer.playerWidth)
            playerView.layer.cornerRadius = BoardScreenPointer.playerWidth / 2
            
            playerView.isUserInteractionEnabled = true
            let gesture = UIPanGestureRecognizer(target: self, action: #selector(moveView(gesture:)))
            gesture.minimumNumberOfTouches = 1
            gesture.maximumNumberOfTouches = 2
            playerView.addGestureRecognizer(gesture)
            
            switch type {
            case .attacking:
                playerView.setupNumber(item + 1)
                playerView.center = BoardScreenPointer.getPlayerCoordinates(frame: boardImageView.frame, type: type, side: sideOfCourt)[item]
                attackingPlayers.append(playerView)
            case .defending:
                playerView.alpha = 0
                playerView.center = BoardScreenPointer.getPlayerCoordinates(frame: boardImageView.frame, type: type, side: sideOfCourt)[item]
                
                defendingPlayers.append(playerView)
            }
            view.addSubview(playerView)
        }
    }
     
     func showDefendingPlayers() {
         defendingPlayers.forEach { view in
             UIView.animate(withDuration: 0.5) {
                 view.alpha = 1
             }
         }
         view?.bringSubviewToFront(ballImageView)
     }
    
    func hideDefendingPlayers() {
        stateOfDefenders = .isHiding
        defendingPlayers.forEach { view in
            UIView.animate(withDuration: 0.5) {
                view.backgroundColor = .black
                view.alpha = 0
            } completion: { _ in
                view.removeFromSuperview()
            }
        }
        defendingPlayers = []
    }
    
    func showOrHideDefenders() {
        switch stateOfDefenders {
        case .isHidden:
            addPlayer(type: .defending, backgroundColor: .red)
            showDefendingPlayers()
            makeCollisionOnPlayersViews()
            stateOfDefenders = .isShowed
        case .isShowed:
            collisionBehavior = UICollisionBehavior(items: attackingPlayers)
            collisionBehavior.action = {
                self.attackingPlayers.forEach { $0.transform = CGAffineTransform.identity }
            }
            hideDefendingPlayers()
            stateOfDefenders = .isHidden
        case .isHiding:
            return
        }
    }
    
    func addBallView() {
        ballImageView = UIImageView(frame: .init(x: 0, y: 0, width: BoardScreenPointer.ballWidth, height: BoardScreenPointer.ballWidth))
        ballImageView.center =  BoardScreenPointer.getBallCenterPoint(frame: boardImageView.frame, side: sideOfCourt)
        ballImageView.layer.cornerRadius = ballImageView.frame.width / 2
        ballImageView.image = BoardScreenImages.ballImage
        ballImageView.isUserInteractionEnabled = true
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(moveBall(gesture:)))
        ballImageView.addGestureRecognizer(gesture)
        ballImageView.dropShadow()
        view?.addSubview(ballImageView)
    }
    
    func makeCollisionOnPlayersViews() {
        guard let view else { return }
        
        animator = UIDynamicAnimator(referenceView: view)
        
        collisionBehavior = UICollisionBehavior(items: attackingPlayers + defendingPlayers)
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let insets = UIEdgeInsets(top: self.boardImageView.frame.minY,
                                      left: 0,
                                      bottom: view.safeAreaInsets.bottom + 25,
                                      right: 0)
            
            self.collisionBehavior.setTranslatesReferenceBoundsIntoBoundary(with: insets)
        }
        
        collisionBehavior.action = {
            self.attackingPlayers.forEach { $0.transform = CGAffineTransform.identity }
        }
    
        animator.addBehavior(collisionBehavior)
    }

    
    @objc private func moveView(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        guard let gestureView = gesture.view else { return }
        
        attachBallToPlayer(gestureView: gestureView)
        
        switch gesture.state {
        case .cancelled, .ended, .failed:
            isIntersectBallWithPlayer = false
            isBallWithPlayer = false
        default: break
        }
        
        gestureView.center = CGPoint(x: gestureView.center.x + translation.x,
                                     y: gestureView.center.y + translation.y)
        gesture.setTranslation(.zero, in: view)
        bringBackIfOutOfBounds(view: gestureView)
        animator.updateItem(usingCurrentState: gestureView)
    }
    
    @objc private func moveBall(gesture: UIPanGestureRecognizer) {
        isBallWithPlayer = false
        
        let translation = gesture.translation(in: view)
        guard let gestureView = gesture.view else { return }
        gestureView.center = CGPoint(x: gestureView.center.x + translation.x,
                                     y: gestureView.center.y + translation.y)
        gesture.setTranslation(.zero, in: view)
        bringBackIfOutOfBounds(view: gestureView)
    }
    
    private func bringBackIfOutOfBounds(view: UIView) {
        let distance = BoardScreenPointer.playerWidth / 2
        
        if view.center.x < boardImageView.frame.minX + distance {
            view.center.x = boardImageView.frame.minX + distance
        } else if view.center.x > boardImageView.frame.maxX - distance {
            view.center.x = boardImageView.frame.maxX - distance
        }
        
        if view.center.y < boardImageView.frame.minY + distance {
            view.center.y = boardImageView.frame.minY + distance
        } else if view.center.y > boardImageView.frame.maxY - distance {
            view.center.y = boardImageView.frame.maxY - distance
        }
    }
    
    func shootBall() {
        let pointToShoot = BoardScreenPointer.getBasketCenterPoint(frame: boardImageView.frame, side: sideOfCourt)
        
        guard pointToShoot != ballImageView.center else { return }
        
        let radians = CGFloat(rotationAngle / 180 * Double.pi)
        rotationAngle == 360 ? (rotationAngle = 180) : (rotationAngle += 180)
        UIView.animate(withDuration: 0.85) {
            self.ballImageView.center = pointToShoot
            self.ballImageView.transform = CGAffineTransform(rotationAngle: radians)
        }
        
        isBallShooted = true
    }
    
    func setPlayersToOriginPoints() {
        animator.removeAllBehaviors()
        let attackingPlayersCoordinates = BoardScreenPointer.getPlayerCoordinates(frame: boardImageView.frame, type: .attacking, side: sideOfCourt)
        let defendingPlayersCoordinates = BoardScreenPointer.getPlayerCoordinates(frame: boardImageView.frame, type: .defending, side: sideOfCourt)
        let ballPoint = BoardScreenPointer.getBallCenterPoint(frame: boardImageView.frame, side: sideOfCourt)
        
        UIView.animate(withDuration: 0.5) {
            self.ballImageView.center = ballPoint
        } completion: { _ in
            self.isBallShooted = false
        }
        
        animator.removeAllBehaviors()
        
        var index = 0
        var secondIndex = 0
        
        attackingPlayers.forEach { view in
            UIView.animate(withDuration: 0.5) {
                view.center = attackingPlayersCoordinates[index]
            }
            index += 1
        }
        
        if stateOfDefenders == .isShowed {
            defendingPlayers.forEach { view in
                UIView.animate(withDuration: 0.5) {
                    view.center = defendingPlayersCoordinates[secondIndex]
                }
                secondIndex += 1
            }
        }
        makeCollisionOnPlayersViews()
    }
     
     func changeSideOfCourt() {
         sideOfCourt == .home ? (sideOfCourt = .away) : (sideOfCourt = .home)
         setPlayersToOriginPoints()
     }
}


//MARK: - Helper for attach ballView to PlayerView
extension BasketBoardInstaller {
    private func attachBallToPlayer(gestureView: UIView) {
        if gestureView.frame.intersects(ballImageView.frame) {
            isIntersectBallWithPlayer = true
            isBallShooted = false
        }
        
        if isIntersectBallWithPlayer {
            var identX: CGFloat = 0
            var identY: CGFloat = 0
            
            if !isBallWithPlayer {
                if ballImageView.center.x < gestureView.center.x {
                    identX = -13
                    xPointIdentFromBall = identX
                } else {
                    identX = 13
                    xPointIdentFromBall = identX
                }
                
                if ballImageView.center.y < gestureView.center.y {
                    identY = 15
                    yPointIdentFromBall = identY
                } else {
                    identY = -15
                    yPointIdentFromBall = identY
                }
            } else {
                identX = xPointIdentFromBall
                identY = yPointIdentFromBall
            }
            
        
            ballImageView.center.x = gestureView.center.x + identX
            ballImageView.center.y = gestureView.center.y - identY
            
            
            isBallWithPlayer = true
        }
    }
}
