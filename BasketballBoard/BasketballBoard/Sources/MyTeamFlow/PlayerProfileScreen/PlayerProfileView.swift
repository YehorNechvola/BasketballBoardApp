//
//  PlayerProfileView.swift
//  BasketballBoard
//
//  Created by Rush_user on 12.02.2026.
//

import SwiftUI

struct PlayerProfileView: View {
    @EnvironmentObject var teamViewModel: MyTeamViewModel
    var body: some View {
        VStack {
            Image(.playerPlaceholder)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .backgroundStyle(Color.gray.opacity(0.3))
                .frame(height: 200)
            Spacer()
        }
    }
}

#Preview {
    PlayerProfileView()
}
