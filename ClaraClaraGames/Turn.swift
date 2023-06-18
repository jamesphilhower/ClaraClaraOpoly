import SwiftUI

class Turn {
    var startLocation: Int
    var endLocation: Int
    var options: [String]
    var moneyChange: (amount: Int, recipient: String)
    var consecutiveDoubles: Int
    var isRollOptionEnabled: Bool
    var turnRecord: String

    init(startLocation: Int, endLocation: Int, options: [String], moneyChange: (amount: Int, recipient: String), consecutiveDoubles: Int, isRollOptionEnabled: Bool, turnRecord: String) {
        self.startLocation = startLocation
        self.endLocation = endLocation
        self.options = options
        self.moneyChange = moneyChange
        self.consecutiveDoubles = consecutiveDoubles
        self.isRollOptionEnabled = isRollOptionEnabled
        self.turnRecord = turnRecord
    }
    
    // Function to check if dice values match and update consecutive doubles
    func checkDiceValues(dice1: Int, dice2: Int) {
        if dice1 == dice2 {
            consecutiveDoubles += 1
        } else {
            consecutiveDoubles = 0
        }
        
        // Check if the number of consecutive doubles is >= 3
        if consecutiveDoubles >= 3 {
            enactGoToJail()
        }
        
        // Enable or disable the roll option based on consecutive doubles
        isRollOptionEnabled = (consecutiveDoubles < 3)
    }
    
    // Function to enact "Go to Jail" action
    func enactGoToJail() {
        // Implement your logic for sending the player to jail
        // Set the player's location to the jail position
        // Update any other game state or player information as necessary
    }
    
    // Function to store the turn in a record
    func storeTurn() {
        // Implement your logic for storing the turn record
        // You can use an array or any other data structure to store the turns
        // Store the necessary information about the turn, such as start and end location, options, money change, etc.
    }
}
