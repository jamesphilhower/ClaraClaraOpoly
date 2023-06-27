
import SwiftUI

struct Move {
    let originalIndex: Int
    let newIndex: Int
}

class PlayersData: ObservableObject {
    @Published var players: [Player] = []
    @Published var roll: Int = 0
    @Published var latestMove: Move = Move(originalIndex: 0, newIndex: 0)
    @Published var currentPlayerIndex: Int = 0
}


class Player: Identifiable, Equatable, ObservableObject, Hashable {
    var playersData: PlayersData
    @Published var cardData: CardsData
    var propertiesData: PropertiesData
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
    
    init(playersData: PlayersData, cards: CardsData, propertiesData: PropertiesData, id: Int, name: String, isAI: Bool) {
        self.playersData = playersData
        self.cardData = cards
        self.propertiesData = propertiesData
        self.id = id
        self.name = name
        self.isAI = isAI
        self.money = 1500
        self.getOutOfJailCards = 0
        self.consecutiveTurnsInJail = 0
        self.location = 0
        self.inJail = false
        self.ownsProperties = true //false
    }
    
    func draw(_ type: String) async {
        switch type {
        case "chance":
            DispatchQueue.main.async {
                self.cardData.chanceDrawIndex = ( self.cardData.chanceDrawIndex + 1 ) % 3
            }
            // waiting for the update to propogate?
            do {
                try await Task.sleep(nanoseconds: 500_000_000)
            }
            catch{
                print("FUCK")
            }
            await cardData.chanceDrawPile[cardData.chanceDrawIndex].action(self)

        case "chest":
            cardData.communityChestDrawIndex = ( cardData.communityChestDrawIndex + 1 ) % 15
        default:
            print("YOU FUCKED UP!!!!")
        }
    }

    func hasFundsFor(_ price: Int) -> Bool {
            // Implement logic to check if the player has enough funds
            return money >= price
        }
    
    // Function to handle paying to get out of jail
    func payToGetOutOfJail() {
        payFee(50)
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
        self.location = 20
    }
    
    func move(spaces: Int) async {
        // Todo needs to be done in a smarter way so that it's not always 2 seconds but based on spaces
        let totalDuration: Double = 2.0  // Total duration for the move in seconds
        let sleepInterval = totalDuration / Double(spaces)  // Calculate sleep interval
        
        for _ in 0..<spaces {
            if self.location == 39 {
                self.location = 0
            } else {
                self.location += 1
            }
            DispatchQueue.main.async {
                
                self.playersData.roll += 1
                
            }
            do {
                try await Task.sleep(nanoseconds: UInt64(sleepInterval * 1_000_000_000))  // Convert sleep interval to nanoseconds
            } catch {
                // Handle sleep error
                print("Error occurred during sleep")
            }
        }
    }


    func movePlayerToProperty(propertyName: String) async {
        print("Yeah this is working out bro")
        
        let endLocation = propertiesData.spaces.firstIndex(where: { $0.name == propertyName })
        if (endLocation == nil) {
            print("yeah we looked for \(propertyName) but didn't get it")
            return
        }
        let spacesToMove = endLocation! > self.location ? endLocation! - self.location : 40 - (self.location - endLocation!)
        await move(spaces: spacesToMove)
        print("After the moves", self.location)
    }

    func moveToNearest(propertyGroup: String) async {
       
        let currentIndex = self.location
        var counter = 1
        var endLocation: Int?

        while endLocation == nil {
            let index = (currentIndex + counter) % 40
            if propertiesData.spaces[index].group == propertyGroup {
                endLocation = index
            } else {
                counter += 1
            }
        }

        await move(spaces: counter)
        
        if let currentProp = propertiesData.spaces[self.location] as? Property {
            if currentProp.owner == nil {
                //Todo
                print("could buy")
            }
            else if currentProp.owner != self {
                print("I don't own it")
                payPlayer(propertyGroup == "rr" ? 2 * calculateRent(for: currentProp) : 10 * abs(playersData.latestMove.newIndex - playersData.latestMove.newIndex), player: currentProp.owner!)
            }
            else {
                print("own, no further action")
            }
        }
    }

    func goBankruptToPlayer(player: Player){
        func goBankruptToPlayer(player: Player) {
            for property in propertiesData.properties {
                if property.owner == self {
                    property.owner = player
                }
            }
            player.getOutOfJailCards += self.getOutOfJailCards
            self.getOutOfJailCards = 0
            player.money += self.money
            self.money = 0
        }
    }
    
    func goBankruptToBank() {
        for property in propertiesData.properties {
            if property.owner == self {
                property.owner = nil
            }
        }
        // Todo, add a skip function so I don't have more turns
    }
    func payBank(_ amount: Int){
        self.money -= amount
    }

    func payFee(_ amount: Int){
        // Todo freeparking
        payBank(amount)
    }
    
    func payPlayer(_ amount: Int, player: Player){
        
        if self.money >= amount {
            self.money -= amount
            player.money += amount
        } else {
            // Todo need to do some property management
        }

    }

    func payOtherPlayers(_ amount: Int){
        let totalPayment = amount * (playersData.players.count - 1)
        
        if self.money >= totalPayment {
            self.money -= totalPayment
            for player in playersData.players {
                if player != self {
                    player.money += amount
                }
            }
        } else {
            // Todo need to do some property management
        }
        
    }

    func moveBackwards(_ spaces: Int) async {
        
        let totalDuration: Double = 2.0  // Total duration for the move in seconds
        let sleepInterval = totalDuration / Double(spaces)  // Calculate sleep interval
        
        for _ in 0..<spaces {
            if self.location == 0 {
                self.location = 39
            } else {
                self.location -= 1
            }
            
            DispatchQueue.main.async {
                self.playersData.roll += 1
            }
            
            do {
                try await Task.sleep(nanoseconds: UInt64(sleepInterval * 1_000_000_000))  // Convert sleep interval to nanoseconds
            } catch {
                // Handle sleep error
                print("Error occurred during sleep")
            }
        }
    }

    
    func payForRepairs() {
        var totalCost = 0

        for property in propertiesData.properties {
            if property.owner == self {
                if let buildableProperty = property as? BuildableProperty {
                    let houseCount = buildableProperty.numberHouses
                    let hotelCount = buildableProperty.hasHotel ? 1 : 0

                    totalCost += houseCount * buildableProperty.housePrice
                    totalCost += hotelCount * buildableProperty.hotelPrice
                }
            }
        }

        print("Total cost for repairs: $\(totalCost)")
        self.payFee(totalCost)
    }



    func collectFromBank(_ amount: Int){
        self.money += amount
    } 

    func buyProperty(property: Property) {
        if let propertyIndex = propertiesData.properties.firstIndex(where: { $0.name == property.name }) {
            propertiesData.properties[propertyIndex].owner = self
        }
    }

    func handleIncomeTax() {
        let totalPropertyValue = propertiesData.properties.reduce(0){ sum, property in
            if property.owner == self {
                return sum + property.purchasePrice
            }
            return sum
        }
        
        let totalHousesAndHotelsCost = propertiesData.properties.reduce(0) { sum, property in
            if let buildableProperty = property as? BuildableProperty {
                return sum + (buildableProperty.numberHouses * buildableProperty.housePrice) + (buildableProperty.hasHotel ? buildableProperty.hotelPrice : 0)
            }
            return sum
        }
        
        let totalAssetsCost = self.money + totalHousesAndHotelsCost
        let incomeTax = min(totalAssetsCost, 200)
        
        print("Total property value: $\(totalPropertyValue)")
        print("Total purchase cost of buildings: $\(totalHousesAndHotelsCost)")
        print("Income tax: $\(incomeTax)")
    }


    
    func handleFreeParking(){
        
    }
    
    
    
    func executeCards() async {
        
        // Execute chance cards
        for gameCard in self.cardData.chanceDrawPile {
            let cardName = gameCard.text

            DispatchQueue.main.async {
                self.cardData.chanceDrawIndex = ( self.cardData.chanceDrawIndex + 1 ) % 16
            }
            // waiting for the update to propogate?
            do {
                try await Task.sleep(nanoseconds: 500_000_000)
            }
            catch{
                print("FUCK")
            }
            
            print("--- Chance Card: \(cardName) ---")
            print("Before: $\(self.money) Loc: \(self.location)") // Print player status before executing the card

            await Task.sleep(2_000_000_000) // Delay for 1 second

            await gameCard.action(self) // Execute the card action

            print("After: $\(self.money) Loc: \(self.location)") // Print player status after executing the card
            print("")

            print("----------")
            await Task.sleep(3_000_000_000) // Delay for half a second as a spacer
            print("")
        }

        // Execute community chest cards
        for gameCard in self.cardData.communityChestDrawPile {
            let cardName = gameCard.text
            
            
            DispatchQueue.main.async {
                self.cardData.communityChestDrawIndex = ( self.cardData.communityChestDrawIndex + 1 ) % 16
            }
            // waiting for the update to propogate?
            do {
                try await Task.sleep(nanoseconds: 500_000_000)
            }
            catch{
                print("FUCK")
            }
            
            
            print("--- Community Chest Card: \(cardName) ---")
            print("Before: $\(self.money) Loc: \(self.location)") // Print player status before executing the card

            await Task.sleep(2_000_000_000) // Delay for 1 second

            await gameCard.action(self) // Execute the card action

            print("After: $\(self.money) Loc: \(self.location)") // Print player status after executing the card
            print("")

            print("----------")
            await Task.sleep(3_000_000_000) // Delay for half a second as a spacer
            print("")
        }
    }
}


