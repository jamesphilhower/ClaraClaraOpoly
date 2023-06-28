//
//  PlayerTokensView.swift
//  ClaraClaraGames
//
//  Created by James Philhower on 6/27/23.
//

import SwiftUI

struct PlayerTokensView: View {
    @ObservedObject var playersData: PlayersData
    @Binding var cellCenters: [Int: CGPoint]
    var body: some View {
        ForEach(playersData.players, id: \.self){ player in
            
            let index = player.location
            let x = cellCenters[index]!.x
            let y = cellCenters[index]!.y
            
            withAnimation(.default) {
                Circle().frame(width: 14, height: 14).position(x: x, y: y).foregroundColor(.blue)
            }
        }
    }
}
