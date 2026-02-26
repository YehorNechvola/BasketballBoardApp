//
//  PlayerItemViewCell.swift
//  BasketballBoard
//
//  Created by Eva on 04.06.2024.
//

import SwiftUI

struct PlayerItemViewCell: View {
    let player: PlayerCore
    let playerImage: UIImage
    
    private var playerImageWidth: CGFloat { 35 }
    
    var body: some View {
        HStack(spacing: 20) {
            Image(uiImage: playerImage)
                .resizable()
                .scaledToFill()
                .frame(width: playerImageWidth, height: playerImageWidth)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.black, lineWidth: 0.5))
            
            Text(player.name + " " + player.surname)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.gray)
        }
    }
}
