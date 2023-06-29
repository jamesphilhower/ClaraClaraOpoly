
import SwiftUI

class Player: Identifiable, Equatable, ObservableObject, Hashable {
    var playersData: PlayersData
    var propertiesData: PropertiesData
    let id: Int
    var name: String
    var consecutiveTurnsInJail: Int
    // Todo do AI
    var isAI: Bool
    // Todo either let people pick, assign, or switch to / add symbols
    var color: Color = Color(red: Double.random(in: 0...1),
                             green: Double.random(in: 0...1),
                             blue: Double.random(in: 0...1))
    var iconName: String


    @Published var cardData: CardsData
    @Published var money: Int
    @Published var getOutOfJailCards: Int
    @Published var location: Int
    @Published var inJail: Bool
    @Published var ownsProperties: Bool
    
    init(playersData: PlayersData, cards: CardsData, propertiesData: PropertiesData, id: Int, name: String, isAI: Bool, iconName: String) {
        self.playersData = playersData
        self.cardData = cards
        self.propertiesData = propertiesData
        self.id = id
        self.name = name
        self.isAI = isAI
        self.money = 1499
        self.getOutOfJailCards = 0
        self.consecutiveTurnsInJail = 0
        self.location = 0
        self.inJail = false
        self.ownsProperties = true //Todo false
        self.iconName = iconName
    }
    
    func drawCard(_ type: String) async {
        switch type {
        case "chance":
            DispatchQueue.main.async {
                self.cardData.chanceDrawIndex = ( self.cardData.chanceDrawIndex + 1 ) % 16
            }
            // Todo-- used to wait for the update to propogate
            do {
                try await Task.sleep(nanoseconds: 500_000_000)
            }
            catch{
                print("Failed to sleep")
            }
            await cardData.chanceDrawPile[cardData.chanceDrawIndex].action(self)

        case "chest":
            DispatchQueue.main.async {
                
                self.cardData.communityChestDrawIndex = ( self.cardData.communityChestDrawIndex + 1 ) % 16
            }
            do {
                try await Task.sleep(nanoseconds: 500_000_000)
            }
            catch{
                print("Failed to sleep")
            }
            await cardData.communityChestDrawPile[cardData.chanceDrawIndex].action(self)

            
        default:
            print("Incorrect string passed to drawCard")
        }
    }

    func buyProperty(property: Property) {
        if let propertyIndex = propertiesData.properties.firstIndex(where: { $0.name == property.name }) {
            propertiesData.properties[propertyIndex].owner = self
        }
    }

    // Todo free parking
    func handleFreeParking(){
        
    }
}


