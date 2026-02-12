//
//  BasketballBoardApp.swift
//  BasketballBoard
//
//  Created by Eva on 29.05.2024.
//

import SwiftUI

@main
struct BasketballBoardApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                BoardCoordinatorView()
                    .tabItem {
                        Image(systemName: "clipboard.fill")
                        Text("Board")
                    }
    
                MyTeamCoordinatorView()
                    .tabItem {
                        Image(systemName: "person.3.sequence")
                        Text("My Team")
                    }
                
                Text("My games")
                    .tabItem {
                        Image(systemName: "figure.basketball")
                        Text("My Games")
                    }
                
                Text("Preferences")
                    .tabItem {
                        Image(systemName: "gearshape.fill")
                        Text("Preferences")
                    }
                    
            }
            .tint(.black)
            .onAppear() {
                UITabBar.appearance().backgroundColor = .systemBrown
            }
        }
    }
}
