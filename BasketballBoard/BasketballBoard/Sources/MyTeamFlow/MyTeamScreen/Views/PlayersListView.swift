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
                
                if viewModel.myTeams.isEmpty {
                    showNonTeamPlaceholder()
                } else if viewModel.startingPlayers.isEmpty && viewModel.benchPlayers.isEmpty {
                    showEmptyTeamPlaceholder()
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
    
    func showNonTeamPlaceholder() -> some View {
        VStack {
            Text("Create new team for adding players")
                .foregroundStyle(.gray)
            Button {
                viewModel.createNewTeamPressed.toggle()
            } label: {
                Text("+new team")
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    .background(.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 10), style: FillStyle())
            }
        }
    }
    
    func showEmptyTeamPlaceholder() -> some View {
        Text("Add players to current team")
            .foregroundStyle(.gray)
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
