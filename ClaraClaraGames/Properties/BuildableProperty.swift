import SwiftUI

class BuildableProperty: Property {
    @Published var numberHouses: Int
    let housePrice: Int
    let hotelPrice: Int
    let sellHouseFor: Int
    let sellHotelFor: Int
    @Published var hasHotel: Bool
    let housingRates: [Int]
    let hotelRate: Int
    
    init(
        name: String,
        purchasePrice: Int,
        group: String,
        isMortgaged: Bool = false,
        iconName: String,
        mortgageValue: Int = 0,
        unMortgageCost: Int = 0,
        baseRent: Int = 0,
        numberHouses: Int = 0,
        hasHotel: Bool = false,
        housingRates: [Int] = [],
        hotelRate: Int = 0,
        housePrice: Int = 0,
        hotelPrice: Int = 0,
        sellHouseFor: Int = 0,
        sellHotelFor: Int = 0,
        color: Color
    ) {
        self.numberHouses = numberHouses
        self.hasHotel = hasHotel
        self.housingRates = housingRates
        self.hotelRate = hotelRate
        self.housePrice = housePrice
        self.hotelPrice = hotelPrice
        self.sellHouseFor = sellHouseFor
        self.sellHotelFor = sellHotelFor
        super.init(
            name: name,
            purchasePrice: purchasePrice,
            group: group,
            isMortgaged: isMortgaged,
            mortgageValue: mortgageValue,
            unMortgageCost: unMortgageCost,
            baseRent: baseRent,
            iconName: iconName,
            color: color
        )
    }
    
    func buyBuilding() {
        guard let owner = owner else {
            return
        }
        
        guard !isMortgaged else {
            return
        }
        
        guard owner.money >= (numberHouses < 4 ? housePrice : hotelPrice) else {
            return
        }
        
        owner.money -= (numberHouses < 4 ? housePrice : hotelPrice)
        if numberHouses < 4 {
            numberHouses += 1
        } else {
            hasHotel = true
        }
        
    }
    
    func sellBuilding() {
        guard let owner = owner else {
            return
        }
        
        guard !isMortgaged else {
            return
        }
        
        owner.money += (hasHotel ? sellHotelFor : sellHouseFor)
        if hasHotel {
            hasHotel = false
        } else if numberHouses > 0 {
            numberHouses -= 1
        } else {
            return
        }
    }
}
