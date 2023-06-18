class Property {
    let name: String
    var isMortgaged: Bool
    let mortgageValue: Int
    var owner: Player?
    var baseRent: Int
    var siblings: [Property]
    
    init(name: String, isMortgaged: Bool, mortgageValue: Int, baseRent: Int, siblings: [Property]) {
        self.name = name
        self.isMortgaged = isMortgaged
        self.mortgageValue = mortgageValue
        self.baseRent = baseRent
        self.siblings = siblings
    }
}

class Railroad: Property {
}

class BuildableProperty: Property {
    var numberHouses: Int
    var hasHotel: Bool
    var housingRates: [Int]
    var hotelRate: Int
    
    init(name: String, isMortgaged: Bool, mortgageValue: Int, baseRent: Int, siblings: [Property], numberHouses: Int, hasHotel: Bool, housingRates: [Int], hotelRate: Int) {
        self.numberHouses = numberHouses
        self.hasHotel = hasHotel
        self.housingRates = housingRates
        self.hotelRate = hotelRate
        super.init(name: name, isMortgaged: isMortgaged, mortgageValue: mortgageValue, baseRent: baseRent, siblings: siblings)
    }
}

class Utility: Property {
}
