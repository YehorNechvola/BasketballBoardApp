//
//  PlayerView.swift
//  BasketballBoard
//
//  Created by Yehor on 29.05.2024.
//

import UIKit

final class PlayerView: UIView {
    
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType { .ellipse }
   
    private lazy var numberOfPlayerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 27)
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -6, dy: -6).contains(point)
    }
    
    func setupNumber(_ number: Int) {
        numberOfPlayerLabel.text = "\(number)"
    }
}

private extension PlayerView {
    func setup() {
        addSubview(numberOfPlayerLabel)
        NSLayoutConstraint.activate([
            numberOfPlayerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            numberOfPlayerLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            numberOfPlayerLabel.widthAnchor.constraint(equalTo: widthAnchor),
            numberOfPlayerLabel.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
}
