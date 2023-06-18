import SwiftUI

struct DiceRollResult {
    var diceRoll1: Int
    var diceRoll2: Int
    var diceTotal: Int
}

func rollDice() -> DiceRollResult {
    let diceRoll1 = rollDie()
    let diceRoll2 = rollDie()
    let diceTotal = diceRoll1 + diceRoll2
    return DiceRollResult(diceRoll1: diceRoll1, diceRoll2: diceRoll2, diceTotal: diceTotal)
}

func rollDie() -> Int {
    return Int.random(in: 1...6)
}

func getLocationOfJailForGameBoard() -> Int {
    return 20
}


func loadGameData() {
    // Retrieve the saved game data object from the device storage
    if let savedData = UserDefaults.standard.data(forKey: "SavedGameData") {
//            do {
//                // Decode the saved game data object
//                let decoder = JSONDecoder()
//                let savedGameData = try decoder.decode(SavedGameData.self, from: savedData)
//
//                // Update the state variables with the loaded data
//                playersCount = savedGameData.playersCount
//                gameBoard = savedGameData.gameBoard
//                playerNames = savedGameData.playerNames
//                currentPlayerIndex = savedGameData.currentPlayerIndex
//                players = savedGameData.players
//                diceRoll = savedGameData.diceRoll
//                consecutiveDoubles = savedGameData.consecutiveDoubles
//                inJail = savedGameData.inJail
//            } catch {
//                // Handle decoding error
//                print("Failed to decode saved game data:", error)
//            }
    }
}

// Function to save the game data
func saveGameData() {
    // Create a game data object with the current state variables
//        let savedGameData = SavedGameData(
//            playersCount: playersCount,
//            gameBoard: gameBoard,
//            playerNames: playerNames,
//            currentPlayerIndex: currentPlayerIndex,
//            players: players,
//            diceRoll: diceRoll,
//            consecutiveDoubles: consecutiveDoubles,
//            inJail: inJail
//        )
    
    // Encode the game data object
//        do {
//            let encoder = JSONEncoder()
//            let encodedData = try encoder.encode(savedGameData)
//
//            // Save the encoded data to the device storage
//            UserDefaults.standard.set(encodedData, forKey: "SavedGameData")
//        } catch {
//            // Handle encoding error
//            print("Failed to encode game data:", error)
//        }
}

func calculateRent(for property: Property) -> Int {
    if property.isMortgaged {
        return 0
    }
    
    switch property {
    case let utility as Utility:
        let ownedUtilitiesCount = property.siblings.reduce(0) { result, property in
            return result + (property.owner == property.owner ? 1 : 0)
        }
        return  utility.baseRent * ownedUtilitiesCount == 1 ? 4 : 10
        
    case _ as Railroad:
        let ownedRailroadsCount = property.siblings.reduce(0) { result, property in
            return result + (property.owner == property.owner ? 1 : 0)
        }
        return Int(pow(2.0, Double(ownedRailroadsCount - 1))) * 25
        
    case let buildable as BuildableProperty:
        if buildable.hasHotel {
            return buildable.hotelRate
        } else {
            let ownedHousesCount = buildable.numberHouses
            return buildable.housingRates[ownedHousesCount]
        }
        
    default:
        fatalError("Invalid property type")
    }
}
