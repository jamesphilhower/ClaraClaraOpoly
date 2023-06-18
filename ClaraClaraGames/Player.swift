
import SwiftUI

class PlayersData: ObservableObject {
    @Published var players: [Player] = []
}


class Player: Equatable {
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: Int
    var name: String
    var money: Int
    var getOutOfJailCards: Int
    var consecutiveTurnsInJail: Int
    var location: Int
    var inJail: Bool
    var isAI: Bool

    var color: Color = .blue
    
    init(id: Int, name: String, isAI: Bool) {
        self.id = id
        self.name = name
        self.isAI = isAI
        self.money = 500
        self.getOutOfJailCards = 0
        self.consecutiveTurnsInJail = 0
        self.location = 2
        self.inJail = false
    }
    
    // Function to handle paying to get out of jail
    func payToGetOutOfJail() {
        self.inJail = false
    }

    // Function to handle using a get out of jail free card
    func useGetOutOfJailFreeCard() {

        if getOutOfJailCards > 0 {
            getOutOfJailCards -= 1
            consecutiveTurnsInJail = 0
        }
        
        self.inJail = false
    }
    
    func goToJail() {
        self.inJail = true
        self.location = getLocationOfJailForGameBoard()

    }

    // Function to handle rolling the dice and moving the player
    func rollDiceAndMove() {
        let diceResult = rollDice()
        let diceRoll1 = diceResult.diceRoll1
        let diceRoll2 = diceResult.diceRoll2
        let diceTotal = diceResult.diceTotal
        
        // Move the player's location based on the dice roll
        location += diceTotal
        
        // Implement the rules of Monopoly for handling various board positions (e.g., passing Go, landing on properties, chance/community chest cards, etc.)
        //handleBoardPositions()
        
        // Update the player's money, properties, or other game state as necessary
        //updatePlayerState()
        
        // Check if the player rolled doubles and handle the consecutive doubles logic
        if diceRoll1 == diceRoll2 {
            consecutiveTurnsInJail += 1
            if consecutiveTurnsInJail >= 3 {
                goToJail()
            }
        } else {
            consecutiveTurnsInJail = 0
        }
        
        // Proceed with the next turn or end the game if conditions are met
        endTurn()
    }


    // Function to handle ending the turn and progressing to the next player
    func endTurn() {
        // Implement your logic for ending the turn and progressing to the next player
        // Update any necessary game state or player information
    }
}

