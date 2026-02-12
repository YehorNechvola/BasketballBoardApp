//
//  BoardCoordinatorView.swift
//  BasketballBoard
//
//  Created by Rush_user on 12.02.2026.
//

import SwiftUI

struct BoardCoordinatorView: View {
    @StateObject private var coordinator = BoardFlowCoordinator()
    
    var body: some View {
        ZStack {
            NavigationStack(path: $coordinator.path) {
                coordinator.build(page: .board)
            }
            .environmentObject(coordinator)
        }
    }
}
