//
//  BoardFlowCoordinator.swift
//  BasketballBoard
//
//  Created by Rush_user on 12.02.2026.
//

import SwiftUI


final class BoardFlowCoordinator: ObservableObject {
    enum Page: String, Identifiable {
        case board
        
        var id: String {
            self.rawValue
        }
    }
    
    @Published var path = NavigationPath()
    
    func push(_ page: Page) {
        self.path.append(page)
    }
    
    @ViewBuilder
    func build(page: Page) -> some View {
        switch page {
        case .board:
            BoardView()
                .background(.brown.opacity(0.7))
        }
    }
}
