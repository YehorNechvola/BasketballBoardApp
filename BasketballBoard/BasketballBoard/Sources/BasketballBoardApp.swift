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
                BoardView()
                    .tabItem {
                        Image(systemName: "clipboard.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("Board")
                    }
                
                Text("My team")
                    .tabItem {
                        Image(systemName: "person.3.sequence")
                            .resizable()
                            .frame(width: 30, height: 30)
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
            .tint(.black)
        }
    }
}
