//
//  ClaraClaraGamesApp.swift
//  ClaraClaraGames
//
//  Created by James Philhower on 6/17/23.
//

import SwiftUI

@main
struct ClaraClaraGamesApp: App {
    
    @StateObject private var diceAnimationData = DiceAnimationData()
    @StateObject private var players = PlayersData()

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(diceAnimationData).environmentObject(players)
        }
    }
}
