//
//  BasketballBoardApp.swift
//  BasketballBoard
//
//  Created by Eva on 29.05.2024.
//

import SwiftUI

@main
struct BasketballBoardApp: App {
    @StateObject var myTeamViewModel = MyTeamViewModel()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                BoardView()
                    .background(.brown.opacity(0.7))
                    .tabItem {
                        Image(systemName: "clipboard.fill")
                        Text("Board")
                    }
    
                MyTeamView()
                    .background(.brown.opacity(0.3))
                    .environmentObject(myTeamViewModel)
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
            .onAppear() {
                UITabBar.appearance().backgroundColor = .brown.withAlphaComponent(0.5)
            }
//            .tint(.black)
        }
    }
}
