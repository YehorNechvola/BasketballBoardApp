//
//  BoardView.swift
//  BasketballBoard
//
//  Created by Eva on 29.05.2024.
//

import SwiftUI

struct BoardView: UIViewControllerRepresentable {
    typealias BoardVC = BoardViewController
    
    func makeUIViewController(context: Context) -> BoardViewController {
        BoardViewController()
    }
    
    func updateUIViewController(_ uiViewController: BoardViewController, context: Context) { }
}
