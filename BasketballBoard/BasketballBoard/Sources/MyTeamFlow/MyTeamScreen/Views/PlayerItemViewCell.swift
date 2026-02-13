//
//  PlayerItemViewCell.swift
//  BasketballBoard
//
//  Created by Eva on 04.06.2024.
//

import SwiftUI

struct PlayerItemViewCell: View {
    
    var player: PlayerCore
    private var playerImage: Image {
        return Image(.playerPlaceholder)
    }
    
    private var playerImagePadding: CGFloat {
//        if let _ =  player.photo {
//            return 0
//        } else {
            return 6
//        }
    }
    
    private var playerImageWidth: CGFloat {
//        if let _ = player.photo {
//            return 35
//        } else {
            return 23
//        }
    }
    
    var body: some View {
        HStack(spacing: 20) {
            playerImage
                .resizable()
                .scaledToFit()
                .frame(width: playerImageWidth, height: playerImageWidth)
                .padding(playerImagePadding)
                .background(Color.orange)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.black, lineWidth: 0.5))
            
            Text(player.name + " " + player.surname)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.gray)
    
        }
    }
}
