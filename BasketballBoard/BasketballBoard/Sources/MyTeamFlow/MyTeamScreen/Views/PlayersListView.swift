//
//  PlayersListView.swift
//  BasketballBoard
//
//  Created by Eva on 03.06.2024.
//

import SwiftUI
import Combine

struct PlayersListView: View {
    @EnvironmentObject var viewModel: MyTeamViewModel
    @State private var shouldShowMessage: Bool = false
    @State private var cancellable: AnyCancellable?
    @State private var isPresentedActionSheet = false
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack {
                    List {
                        if !viewModel.myTeams.isEmpty {
                            createTeamSection()
                        }
                        
                        if !viewModel.startingPlayers.isEmpty {
                            createPlayerSection(players: viewModel.startingPlayers, header: "Starting players")
                        }
                        
                        if !viewModel.benchPlayers.isEmpty {
                            createPlayerSection(players: viewModel.benchPlayers, header: "Bench players")
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
                
                if viewModel.currentTeamPlayers.isEmpty {
                    Text("Create new team or add players to current team")
                        .foregroundStyle(.gray)
                }
                
                showStartingLinupMessage(proxy: proxy)
            }
        }
        
        .confirmationDialog("Removing player", isPresented: $isPresentedActionSheet) {
            Button(role: .destructive) {
                withAnimation {
                    viewModel.removePlayer(player: viewModel.playerToDelete)
                }
                
            } label: {
                Text("Remove player")
            }
            
            Button(role: .cancel) {
                viewModel.setPlayerToDelete(nil)
            } label: {
                Text("Cancel")
            }
        } message: {
            Text("Are you sure you want to remove \((viewModel.playerToDelete?.name ?? "") + " " + (viewModel.playerToDelete?.surname ?? ""))?")
        }
    }
}


//MARK: - Private methods
private extension PlayersListView {
    func createTeamSection() -> some View {
        Section {
            HStack(spacing: 20) {
                Image(systemName: "list.bullet.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.gray)
                
                Text(viewModel.currentTeam?.name ?? "")
                
                Button {
                    
                } label: {
                    Image(systemName: "")
                }
                .buttonStyle(.borderless)
                 
                
                Spacer()
                
                Button {
                    
                } label: {
                    HStack {
                        Text("switch")
                            .foregroundStyle(.gray)
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.gray)
                    }
                }
                .buttonStyle(.borderless)
            }
            
        } header: {
            Text("Current team")
        }
    }
    
    func createPlayerSection(players: [Player], header: String) -> some View {
        Section {
            ForEach(players, id: \.name) { player in
                PlayerItemViewCell(player: player)
                    .swipeActions {
                        createDeleteButton(for: player)
                        createMoveButton(for: player)
                    }
            }
        } header: {
            Text(header)
        }
    }
    
    func createDeleteButton(for player: Player) -> some View {
        Button() {
            viewModel.setPlayerToDelete(player)
            isPresentedActionSheet = true
        } label: {
            Image(systemName: "trash")
        }
        .tint(.red)
    }
    
    func createMoveButton(for player: Player) -> some View {
        Button() {
            cancelHiddingMessage()
            scheduleHideMessage()
            
            withAnimation(.spring) {
                viewModel.movePlayerToOrFromBench(player)
                shouldShowMessage = viewModel.shouldShowMessage
            }
            
        } label: {
            Label(player.isStartingPlayer ? "To bench" : "To start",
                  systemImage: player.isStartingPlayer ? "arrow.down.square.fill" : "arrow.up.square.fill")
            
        }
        .tint(player.isStartingPlayer ? .yellow : .green)
    }
    
    func showStartingLinupMessage(proxy: GeometryProxy) -> some View {
        let yOffset: CGFloat = shouldShowMessage ? 0 : -25
        
        return VStack {
            Text("Starting linup has already been formed")
                .frame(width: proxy.size.width, height: 25)
                .background(.orange)
            .offset(y: yOffset)
            
            Spacer()
        }
    }
    
    func scheduleHideMessage() {
           cancelHiddingMessage()

        let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
           cancellable = timer.sink { _ in
               withAnimation {
                   shouldShowMessage = false
                   viewModel.shouldShowMessage = false
               }
               
               cancellable?.cancel()
           }
       }

       func cancelHiddingMessage() {
           cancellable?.cancel()
           cancellable = nil
       }
}

#Preview {
    PlayersListView()
        .environmentObject(MyTeamViewModel())
}
