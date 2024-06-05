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
                .foregroundStyle(.placeholder)
                
            Text(player.name + " " + player.surname)
            
            Spacer()
            
            Text("\(player.position.rawValue)")
        }
    }
}

#Preview {
//    @State var player = Player(name: "Test", surname: "Test")
    
    return PlayerItemViewCell(player: Player(name: "test", surname: "test", position: Player.PlayerPosition.center))
}
