//
//  PlayerProfileView.swift
//  BasketballBoard
//
//  Created by Rush_user on 12.02.2026.
//

import SwiftUI

struct PlayerProfileView: View {
    @EnvironmentObject var teamViewModel: MyTeamViewModel
    
    private var player: PlayerCore {
        teamViewModel.selectedPlayerProfile!
    }
    
    @State private var playerUIImage: UIImage?
    
    private var playerPosition: String {
        Player.PlayerPosition(rawValue: player.position)?.positionToString ?? ""
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                createTopPlayerView()
                createPlayerInfoView()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "pencil.line")
                        .foregroundStyle(.black)
                }
            }
        }
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(.brown, for: .navigationBar)
        .background(Color.gray.opacity(0.3))
    }
    
    @ViewBuilder
    private func createTopPlayerView() -> some View {
            Image(uiImage: playerUIImage ?? UIImage(resource: .playerPlaceholder))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 160)
                .background(Color.red)
    }
    
    @ViewBuilder
    private func createPlayerInfoView() -> some View {
        HStack {
            LazyVStack(alignment: .leading, spacing: 5) {
                Text("\(player.name) \(player.surname)")
                    .font(.system(size: 21, weight: .bold, design: .default))
                    Text(teamViewModel.playerProfileDisplayAge)
                    Text(playerPosition)
                
                if let notes = player.notes, !notes.isEmpty {
                    Text(notes)
                        .padding(8)
                        .background(Color.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            Spacer()
        }
    }
}
