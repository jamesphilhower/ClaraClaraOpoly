//
//  CardsData.swift
//  ClaraClaraGames
//
//  Created by James Philhower on 6/26/23.
//

import SwiftUI


private let bothCards: [String: gameCard] = [
    "Advance to Start": gameCard(text: "Advance to Start. +$200.", action: { player in
        await player.movePlayerToProperty(propertyName: "Start")
    }),
    "Get out of Jail Free": gameCard(text: "Get well wish", action: { player in
        player.getOutOfJailCards += 1
    }),
    "Capex": gameCard(text: "Thieves and vandals run through the street. For each house, pay $25. For each hotel, pay $100.", action: { player in
        player.payForRepairs()
    }),
    "Get Sick": gameCard(text: "Go directly to Hospital.", action: { player in
        player.goToJail()
    }),
]

private let chanceCards: [String: gameCard] = [
    
    "Advance to Facemask": gameCard(text: "Advance to Facemask.", action: { player in
        await player.movePlayerToProperty(propertyName: "Facemask")
    }),
    "Advance to Graduation": gameCard(text: "Advance to Graduation.", action: { player in
        await player.movePlayerToProperty(propertyName: "Graduation")
    }),
    "Advance to nearest Utility": gameCard(text: "Advance token to nearest Utility", action: { player in
        await player.moveToNearest(propertyGroup: "utilities")
    }),
    "Advance to nearest Railroad": gameCard(text: "Advance token to the nearest Railroad", action: { player in
        await player.moveToNearest(propertyGroup: "rr")
    }),
    "Find Money on The Ground": gameCard(text: "Find $50 on The Ground", action: { player in
        player.collectFromBank(50)
    }),
    "Go back 3 spaces": gameCard(text: "You forgot your briefcase. Go back 3 spaces", action: { player in
        await player.moveBackwards(3)
    }),
    "Pay poor tax": gameCard(text: "Buy Prescription.", action: { player in
        player.payFee(15)
    }),
    "Advance to R1": gameCard(text: "Advance to R1", action: { player in
        await player.movePlayerToProperty(propertyName: "R1")
    }),
    "Advance to Congress": gameCard(text: "Advance to Congress", action: { player in
        await player.movePlayerToProperty(propertyName: "Congress")
    }),
    "Bribe the witnesses": gameCard(text: "Bribe the witnesses -$50/each", action: { player in
        player.payOtherPlayers(50)
    }),
    "Startup": gameCard(text: "Your startup equity vested. +$150", action: { player in
        player.collectFromBank(150)
    }),
    "The court rules": gameCard(text: "You give up your seat on an overbooked flight. +$100", action: { player in
        player.collectFromBank(100)
    }),
]

private let communityChestCards: [String: gameCard] = [
    "Dogecoin": gameCard(text: "Tax return loophole in your favor.  +$200.", action: { player in
        player.collectFromBank(200)
    }),
    "Hospital bed fees": gameCard(text: "Hospital bed fees. -$50.", action: { player in
        player.payFee(50)
    }),
    "From sale of stock you get $50": gameCard(text: "Class action lawsuit settles. +$50.", action: { player in
        player.collectFromBank(50)
    }),
    "Grand Opera Night. Collect $50 from every player for opening night seats": gameCard(text: "Venmoes for dinner last month come in. +10/each", action: { player in
        player.payOtherPlayers(50)
    }),
    "Holiday Fund matures. Receive $100": gameCard(text: "Startup equity matures. +$100.", action: { player in
        player.collectFromBank(100)
    }),
    "IRS approves business deductions": gameCard(text: "IRS approves business deductions. +$20.", action: { player in
        player.collectFromBank(20)
    }),
    "It's your birthday. Collect $10 from every player": gameCard(text: "Chinese New Year. +$10/each", action: { player in
        player.payOtherPlayers(10)
    }),
    "Unemployment backpay check": gameCard(text: "The DOL backpays your unemployment: +$100.", action: { player in
        player.collectFromBank(100)
    }),
    "Hit by uninsured motorist": gameCard(text: "Hit by uninsured motorist -$100.", action: { player in
        player.payFee(100)
    }),
    "Tuition Interest is due": gameCard(text: "Tuition Interest Payment. -$50.", action: { player in
        player.payFee(50)
    }),
    "Your selfie sells for $25": gameCard(text: "Bring your coins to Coinstar. +$25", action: { player in
        player.collectFromBank(25)
    }),
    "You have won second prize in a beauty contest – Collect $10": gameCard(text: "An Amazon seller pays you for a review. +$10", action: { player in
        player.collectFromBank(10)
    }),
    "You inherit $100": gameCard(text: "Your stimulus check arrives. +$100.", action: { player in
        player.collectFromBank(100)
    }),
]

class CardsData: ObservableObject {
    var chanceDrawPile: [gameCard]
    @Published var chanceDrawIndex = 0
    var communityChestDrawPile: [gameCard]
    @Published var communityChestDrawIndex = 0

    init(){
        self.chanceDrawPile = (Array(chanceCards.values) + Array(bothCards.values)).shuffled()
        self.communityChestDrawPile = (Array(communityChestCards.values) + Array(bothCards.values)).shuffled()
    }
}
