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
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.brown.withAlphaComponent(0.3))
                    .ignoresSafeArea()
                
                PlayersListView()
                
                    .navigationTitle(viewModel.currentTeam?.name ?? "My team")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarBackground(.brown.opacity(0.5), for: .navigationBar)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                
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
        }
    }
}
    
    #Preview {
        MyTeamView()
            .environmentObject(MyTeamViewModel())
    }

