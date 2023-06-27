//
//  ClaraClaraGamesApp.swift
//  ClaraClaraGames
//
//  Created by James Philhower on 6/17/23.
//

import SwiftUI

#if DEBUG
let isDevelopment = true
#else
let isDevelopment = false
#endif

@main
struct ClaraClaraGamesApp: App {
    
    @StateObject private var diceAnimationData = DiceAnimationData()
    @StateObject private var players = PlayersData()
    @StateObject private var properties = PropertiesData()
    @StateObject private var cards = CardsData()

    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(diceAnimationData)
                .environmentObject(players)
                .environmentObject(cards)
                .environmentObject(properties)
        }
    }
}
