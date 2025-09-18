//
//  MyTeamView.swift
//  BasketballBoard
//
//  Created by Eva on 03.06.2024.
//

import SwiftUI

struct MyTeamView: View {
    @EnvironmentObject var viewModel: MyTeamViewModel
    @Environment(\.dismiss) var dismiss
    private var currentTeamPhoto: UIImage? {
        guard let photoData = viewModel.currentTeam?.photo else {
            return nil
        }
        return UIImage(data: photoData)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.brown.withAlphaComponent(0.3))
                    .ignoresSafeArea()
                
                PlayersListView()
                
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarBackground(.brown.opacity(0.5), for: .navigationBar)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                
                            } label: {
                                HStack {
                                    Image(uiImage: currentTeamPhoto ?? UIImage(resource: .ballIcon))
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                        .foregroundStyle(.black)
                                        
                                    Text(viewModel.currentTeam?.name ?? "Current team")
                                        .frame(maxWidth: UIScreen.main.bounds.width * 0.6)
                                    
                                    if viewModel.teamsCount > 1 {
                                        Image(systemName: "arrowtriangle.down.fill")
                                            .resizable()
                                            .frame(width: 10, height: 10)
                                    }
                                }
                            }
                            .disabled(viewModel.myTeams.isEmpty)
                            .opacity(viewModel.myTeams.isEmpty ? 0 : 1.0)
                        }
                        
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                viewModel.createNewPlayerPressed.toggle()
                            } label: {
                                Image(systemName: "person.fill.badge.plus")
                                    .foregroundStyle(.black)
                            }
                            .disabled(viewModel.myTeams.isEmpty)
                            .opacity(viewModel.myTeams.isEmpty ? 0.5 : 1.0)
                        }
                    }
            }
            
            .fullScreenCover(isPresented: $viewModel.createNewTeamPressed) {
                CreateNewTeamScreen()
            }
            
            .fullScreenCover(isPresented: $viewModel.createNewPlayerPressed) {
                CreatePlayerView()
            }
        }
    }
}

#Preview {
    MyTeamView()
        .environmentObject(MyTeamViewModel())
}
