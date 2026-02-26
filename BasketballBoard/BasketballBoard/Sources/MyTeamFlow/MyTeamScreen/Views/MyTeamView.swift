//
//  MyTeamView.swift
//  BasketballBoard
//
//  Created by Eva on 03.06.2024.
//

import SwiftUI

struct MyTeamView: View {
    @EnvironmentObject var viewModel: MyTeamViewModel
    @EnvironmentObject var coordinator: MyTeamFlowCoordinator
    @State private var currentTeamPhoto: UIImage? = nil
    
    private var currentTeam: TeamCore? {
        viewModel.currentTeam
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.gray.opacity(0.3))
                    .ignoresSafeArea()
                
                PlayersListView()
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarBackground(.brown, for: .navigationBar)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                
                            } label: {
                                HStack {
                                    Image(uiImage: currentTeamPhoto ?? UIImage(resource: .ballIcon))
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 38, height: 38)
                                        .clipShape(Circle())
                                        .foregroundStyle(.black)
                                        .onAppear {
                                            updateTeamPhoto()
                                        }
                                        .onChange(of: viewModel.myTeams) { _ , _ in
                                            updateTeamPhoto()
                                        }
                                        
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
                                viewModel.createNewPlayerTap(with: coordinator)
                            } label: {
                                Image(systemName: "person.fill.badge.plus")
                                    .foregroundStyle(.black)
                            }
                            .disabled(viewModel.myTeams.isEmpty)
                            .opacity(viewModel.myTeams.isEmpty ? 0.5 : 1.0)
                        }
                    }
            }
        }
    }
    
    private func updateTeamPhoto() {
        guard let currentTeam = viewModel.currentTeam else { return }
        Task {
            guard let data = await viewModel.getPhotoData(by: currentTeam.teamId) else {
                currentTeamPhoto = nil
                return
            }
            let image = UIImage(data: data)
            
            currentTeamPhoto = image
        }
    }
}

#Preview {
    MyTeamView()
        .environmentObject(MyTeamViewModel())
}
