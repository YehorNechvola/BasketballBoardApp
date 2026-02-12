//
//  MyTeamFlowCoordinator.swift
//  BasketballBoard
//
//  Created by Rush_user on 12.02.2026.
//

import SwiftUI

final class MyTeamFlowCoordinator: ObservableObject {
    enum Page: String, Identifiable {
        case myTeam
        case playerProfile
        
        var id: String {
            self.rawValue
        }
    }
    
    enum FullScreenPage: String, Identifiable {
        case createNewTeam
        case addNewPlayer
        
        var id: String {
            self.rawValue
        }
    }
    
    @Published var path = NavigationPath()
    @Published var fullScreenCover: FullScreenPage?
    
    func push(_ page: Page) {
        self.path.append(page)
    }
    
    func present(fullScreenCover: FullScreenPage) {
        self.fullScreenCover = fullScreenCover
    }
    
    func popLast() {
        path.removeLast()
    }
    
    func dismiss() {
        self.fullScreenCover = nil
    }
    
    @ViewBuilder
    func build(page: Page) -> some View {
        switch page {
        case .myTeam:
            MyTeamView()
        case .playerProfile:
            PlayerProfileView()
        }
    }
    
    @ViewBuilder
    func build(fullScreenCover: FullScreenPage) -> some View {
        switch fullScreenCover {
        case .createNewTeam:
            CreateNewTeamScreen()
        case .addNewPlayer:
            CreatePlayerView()
        }
    }
}
