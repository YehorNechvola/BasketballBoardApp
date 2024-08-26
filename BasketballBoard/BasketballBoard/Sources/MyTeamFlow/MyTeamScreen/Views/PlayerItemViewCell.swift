//
//  PlayerItemViewCell.swift
//  BasketballBoard
//
//  Created by Eva on 04.06.2024.
//

import SwiftUI

struct PlayerItemViewCell: View {
    var player: PlayerCore
    
    var body: some View {
        HStack(spacing: 20) {
            Image(.playerPlaceholder)
                .resizable()
                .scaledToFit()
                .frame(width: 23, height: 23)
                .padding(EdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6))
                .background(Color.orange)
                .clipShape(Circle())
            
            Text(player.name + " " + player.surname)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.gray)
        }
    }
}
