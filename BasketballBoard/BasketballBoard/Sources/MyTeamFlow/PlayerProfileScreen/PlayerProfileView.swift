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
    
    @State private var playerPhoto: UIImage?
    
    private var playerPosition: String {
        Player.PlayerPosition(rawValue: player.position)?.positionToString ?? ""
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                createTopPlayerView()
                createPlayerInfoView()
            }
            .padding(.top, 16)
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
    
    private var playerNumberView: some View {
        ZStack {
            Image(.topIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 37)
            Text("\(player.number)")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color.red)
                .offset(y: 4)
        }
    }
    
    @ViewBuilder
    private func createTopPlayerView() -> some View {
        Image(uiImage: playerPhoto ?? UIImage(resource: .player))
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 160)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.black, lineWidth: 1))
            .task {
                if let data = await teamViewModel.getPhotoData(by: player.id),
                   let image = UIImage(data: data) {
                    playerPhoto = image
                }
            }
    }
    
    @ViewBuilder
    private func createPlayerInfoView() -> some View {
        HStack {
            LazyVStack(alignment: .leading, spacing: 5) {
                LazyHStack(alignment: .bottom) {
                    Text("\(player.name) \(player.surname)")
                        .font(.system(size: 21, weight: .bold))
                    playerNumberView
                }
                
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
