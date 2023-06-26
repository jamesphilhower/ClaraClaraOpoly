//var playerMoney: [String: Int] = [:] // Player names and their corresponding money amounts
//var bankMoney: Int = 0 // Amount of money in the bank
//
//// Function to give money to all players
//func giveMoneyToAllPlayers(amount: Int) {
//    let numberOfPlayers = playerMoney.count
//    if numberOfPlayers > 0 {
//        let amountPerPlayer = amount / numberOfPlayers
//        for player in playerMoney.keys {
//            playerMoney[player, default: 0] += amountPerPlayer
//        }
//    }
//}
//
//// Function to give money from the bank to the player
//func giveMoneyFromBankToPlayer(player: String, amount: Int) {
//    playerMoney[player, default: 0] += amount
//    bankMoney -= amount
//}
//
//// Function to move the player to a specific property
//func movePlayerToProperty(player: String, propertyName: String) {
//    // Implement the logic to move the player to the specified property
//}
//
//let chanceCards: [String: gameCard] = [
//    "Advance to Go": gameCard(text: "Advance to Go. Collect $200.", action: {
//        movePlayerToProperty(player: "Current Player", propertyName: "Go")
//    }),
//    "Advance to Illinois Ave.": gameCard(text: "Advance to Illinois Ave. If you pass Go, collect $200.", action: {
//        movePlayerToProperty(player: "Current Player", propertyName: "Illinois Ave.")
//    }),
//    "Advance to St. Charles Place": gameCard(text: "Advance to St. Charles Place. If you pass Go, collect $200.", action: {
//        movePlayerToProperty(player: "Current Player", propertyName: "St. Charles Place")
//    }),
//    "Advance to nearest Utility": gameCard(text: "Advance token to nearest Utility. If unowned, you may buy it from the Bank. If owned, throw dice and pay owner a total 10 times the amount thrown.", action: {
//        movePlayerToNearestUtility(player: "Current Player")
//    }),
//    "Advance to nearest Railroad": gameCard(text: "Advance token to the nearest Railroad and pay the owner twice the rental to which they are otherwise entitled. If Railroad is unowned, you may buy it from the Bank.", action: {
//        movePlayerToNearestRailroad(player: "Current Player")
//    }),
//    "Bank pays you dividend": gameCard(text: "Bank pays you dividend of $50.", action: {
//        giveMoneyFromBankToPlayer(player: "Current Player", amount: 50)
//    }),
//    "Get out of Jail Free": gameCard(text: "Get out of Jail Free – This card may be kept until needed or sold.", action: {
//        // Implement the logic for using the Get Out of Jail Free card
//    }),
//    "Go back 3 spaces": gameCard(text: "Go back 3 spaces.", action: {
//        movePlayerBackSpaces(player: "Current Player", count: 3)
//    }),
//    "Go directly to Jail": gameCard(text: "Go directly to Jail. Do not pass Go, do not collect $200.", action: {
//        movePlayerToJail(player: "Current Player")
//    }),
//    "Make general repairs on your properties": gameCard(text: "Make general repairs on all your properties. For each house, pay $25. For each hotel, pay $100.", action: {
//        payBank(player: "Current Player", houseRepairCost: 25, hotelRepairCost: 100)
//    }),
//    "Pay poor tax": gameCard(text: "Pay poor tax of $15.", action: {
//        payBank(player: "Current Player", amount: 15)
//    }),
//    "Take a trip to Reading Railroad": gameCard(text: "Take a trip to Reading Railroad. If you pass Go, collect $200.", action: {
//        movePlayerToProperty(player: "Current Player", propertyName: "Reading Railroad")
//    }),
//    "Take a walk on the Boardwalk": gameCard(text: "Take a walk on the Boardwalk. Advance token to Boardwalk.", action: {
//        movePlayerToProperty(player: "Current Player", propertyName: "Boardwalk")
//    }),
//    "You have been elected Chairman of the Board": gameCard(text: "You have been elected Chairman of the Board. Pay each player $50.", action: {
//        giveMoneyToAllPlayers(amount: -50)
//        giveMoneyFromBankToPlayer(player: "Current Player", amount: playerMoney.count * 50)
//    }),
//    "Your building loan matures": gameCard(text: "Your building loan matures. Collect $150.", action: {
//        giveMoneyFromBankToPlayer(player: "Current Player", amount: 150)
//    }),
//    "You have won a crossword competition": gameCard(text: "You have won a crossword competition. Collect $100.", action: {
//        giveMoneyFromBankToPlayer(player: "Current Player", amount: 100)
//    }),
//]
