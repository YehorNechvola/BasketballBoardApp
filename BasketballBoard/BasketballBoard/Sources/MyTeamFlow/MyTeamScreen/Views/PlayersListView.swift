//
//  PlayersListView.swift
//  BasketballBoard
//
//  Created by Eva on 03.06.2024.
//

import SwiftUI

struct PlayersListView: View {
    @EnvironmentObject var viewModel: MyTeamViewModel
    @State var shouldShowView: Bool = false
    
    var body: some View {
        ZStack {
            List {
                if !viewModel.startingPlayers.isEmpty {
                    playerSection(players: viewModel.startingPlayers, header: "Starting players")
                }
                
                if !viewModel.benchPlayers.isEmpty {
                    playerSection(players: viewModel.benchPlayers, header: "Bench players")
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            
            if viewModel.currentTeamPlayers.isEmpty {
                Text("Create new team or add players to current team")
                    .foregroundStyle(.gray)
            }
            
            if shouldShowView {
                Text("Starting linup has already been formed")
            }
        }
    }
}

//MARK: - Private methods
private extension PlayersListView {
    func playerSection(players: [Player], header: String) -> some View {
        Section {
            ForEach(players, id: \.name) { player in
                PlayerItemViewCell(player: player)
                    .swipeActions {
                        deleteButton(for: player)
                        moveButton(for: player)
                    }
            }
        } header: {
            Text(header)
        }
    }
    
    func deleteButton(for player: Player) -> some View {
        Button(role: .destructive) {
            viewModel.removePlayer(player: player)
        } label: {
            VStack {
                Text("Delete")
                Image(systemName: "trash")
            }
        }
    }
    
    func moveButton(for player: Player) -> some View {
        Button() {
            withAnimation(.smooth) {
                viewModel.movePlayerToOrFromBench(player)
                shouldShowView = viewModel.shouldHide
            } completion: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    viewModel.shouldHide = false
                    withAnimation {
                        shouldShowView = false
                    }
                    
                }
            }
            
        } label: {
            Label(player.isStartingPlayer ? "To bench" : "To start",
                  systemImage: player.isStartingPlayer ? "arrow.down.square.fill" : "arrow.up.square.fill")
            
        }
        .tint(player.isStartingPlayer ? .yellow : .green)
    }
}

#Preview {
    PlayersListView()
        .environmentObject(MyTeamViewModel())
}
