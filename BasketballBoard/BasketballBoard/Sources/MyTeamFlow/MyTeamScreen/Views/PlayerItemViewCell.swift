//
//  PlayerItemViewCell.swift
//  BasketballBoard
//
//  Created by Eva on 04.06.2024.
//

import SwiftUI

struct PlayerItemViewCell: View {
    var player: Player
    
    var body: some View {
        HStack(spacing: 20) {
            
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundStyle(.gray)
                
            
            Text(player.name + " " + player.surname)
            
            Text("\(player.position.rawValue)")
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    
    return PlayerItemViewCell(player: Player(name: "test", surname: "test", position: Player.PlayerPosition.center))
}
