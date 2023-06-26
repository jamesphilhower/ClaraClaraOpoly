
import SwiftUI

struct Move {
    let originalIndex: Int
    let newIndex: Int
}
class PlayersData: ObservableObject {
    @Published var players: [Player] = []
    @Published var roll: Int = 0
    @Published var latestMove: Move = Move(originalIndex: 0, newIndex: 0)
}


class Player: Identifiable, Equatable, ObservableObject, Hashable {
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: Int
    var name: String
    @Published var money: Int
    @Published var getOutOfJailCards: Int
    var consecutiveTurnsInJail: Int
    @Published var location: Int
    @Published var inJail: Bool
    var isAI: Bool
    @Published var ownsProperties: Bool

    var color: Color = .blue
    
    init(id: Int, name: String, isAI: Bool) {
        self.id = id
        self.name = name
        self.isAI = isAI
        self.money = 500
        self.getOutOfJailCards = 0
        self.consecutiveTurnsInJail = 0
        self.location = 1
        self.inJail = false
        self.ownsProperties = true //false
    }
    
    func moveForward(){
        self.location += 1
    }
    func hasFundsFor(_ price: Int) -> Bool {
            // Implement logic to check if the player has enough funds
            return money >= price
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
        self.location = 21
    }
}

