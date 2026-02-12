//
//  MyTeamCoordinatorView.swift
//  BasketballBoard
//
//  Created by Rush_user on 12.02.2026.
//

import SwiftUI
import Combine

struct MyTeamCoordinatorView: View {
    @StateObject private var coordinator = MyTeamFlowCoordinator()
    @StateObject private var myTeamViewModel = MyTeamViewModel()
    
    var body: some View {
        ZStack {
            NavigationStack(path: $coordinator.path) {
                coordinator.build(page: .myTeam)
                    .navigationDestination(for: MyTeamFlowCoordinator.Page.self) { page in
                        coordinator.build(page: page)
                    }
                
                    .fullScreenCover(item: $coordinator.fullScreenCover) { fullScreenCover in
                        coordinator.build(fullScreenCover: fullScreenCover)
                    }
            }
            .environmentObject(coordinator)
            .environmentObject(myTeamViewModel)
        }
    }
}
