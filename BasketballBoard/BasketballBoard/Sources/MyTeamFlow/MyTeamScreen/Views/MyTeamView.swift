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
                
                VStack(spacing: 20) {
                    PlayersListView()
                    Spacer()
                }
                .navigationTitle(viewModel.currentTeam?.name ?? "My team")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(.brown.opacity(0.5), for: .navigationBar)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            
                        } label: {
                            Text("edit")
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
