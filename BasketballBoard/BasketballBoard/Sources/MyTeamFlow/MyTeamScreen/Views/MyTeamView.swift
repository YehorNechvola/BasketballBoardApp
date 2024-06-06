//
//  MyTeamView.swift
//  BasketballBoard
//
//  Created by Eva on 03.06.2024.
//

import SwiftUI

struct MyTeamView: View {
    @EnvironmentObject var viewModel: MyTeamViewModel
    
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
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            
                        } label: {
                            Image(systemName: "pencil")
                                .foregroundStyle(.black)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    MyTeamView()
        .environmentObject(MyTeamViewModel())
}
