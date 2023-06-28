import SwiftUI

extension Player {
    func hasFundsFor(_ price: Int) -> Bool {
        return self.money >= price
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
    
    
    func collectFromBank(_ amount: Int){
        self.money += amount
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
        self.payFee(incomeTax)
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
    


    
}
