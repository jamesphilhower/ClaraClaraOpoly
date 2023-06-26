import SwiftUI




enum PropertyError: Error {
    case noOwner
    case insufficientFunds
    case alreadyMortgaged
}

class Start {
    var icon = "flag.checkered"
}

class Jail {
    var icon = "tablecells"
    var icon2 = "hand.raised"
}

class FreeParking {
    var icon = "tree"
}

class PositiveCard {
    var icon = "gift"
}


class AddPropsToTrade {
    var icon = "cart.badge.plus"
}

class AddPropsToDropFromTrade {
    var icon = "trash"
}

class InsufficientMoney {
    var icon = "creditcard.trianglebadge"
}

class getOutOfJail {
    var icon = "giftcard"
}

class confirmTrade {
    var icon = "signature"
}

enum PropertyGroup {
    case brown
    case lightBlue
    case pink
    case orange
    case red
    case yellow
    case green
    case darkBlue

    var color: Color {
        switch self {
        case .brown:
            return .brown
        case .lightBlue:
            return .blue
        case .pink:
            return .pink
        case .orange:
            return .orange
        case .red:
            return .red
        case .yellow:
            return .yellow
        case .green:
            return .green
        case .darkBlue:
            return .blue
        }
    }
}

class Property: Identifiable, ObservableObject, Equatable {
    let name: String
    let iconName: String
    @Published var isMortgaged: Bool
    let mortgageValue: Int
    let unMortgageCost: Int
    @Published var owner: Player?
    let baseRent: Int
    @Published var siblings: [Property]
    
    init(
        name: String,
        isMortgaged: Bool = false,
        mortgageValue: Int = 0,
        unMortgageCost: Int = 0,
        baseRent: Int = 0,
        siblings: [Property] = [],
        iconName: String
    ) {
        self.name = name
        self.isMortgaged = isMortgaged
        self.mortgageValue = mortgageValue
        self.unMortgageCost = unMortgageCost
        self.baseRent = baseRent
        self.siblings = siblings
        self.iconName = iconName
    }
    
    static func ==(lhs: Property, rhs: Property) -> Bool {
        return lhs.name == rhs.name &&
        lhs.isMortgaged == rhs.isMortgaged &&
        lhs.mortgageValue == rhs.mortgageValue &&
        lhs.unMortgageCost == rhs.unMortgageCost &&
        lhs.owner == rhs.owner &&
        lhs.baseRent == rhs.baseRent &&
        lhs.siblings == rhs.siblings
    }
    
    func unMortgage() throws {
        guard let owner = owner else {
            throw PropertyError.noOwner
        }
        
        guard owner.money >= unMortgageCost else {
            throw PropertyError.insufficientFunds
        }
        
        owner.money -= unMortgageCost
        isMortgaged = false
    }
    
    func mortgage() throws {
        guard let owner = owner else {
            throw PropertyError.noOwner
        }
        
        if isMortgaged {
            throw PropertyError.alreadyMortgaged
        }
        
        let mortgageAmount = mortgageValue
        owner.money += mortgageAmount
        isMortgaged = true
    }
}


class Railroad: Property {
    init(name: String, isMortgaged: Bool = false, siblings: [Property] = [],
         iconName: String) {
        super.init(
            name: name,
            isMortgaged: isMortgaged,
            mortgageValue: 0,
            unMortgageCost: 0,
            baseRent: 25,
            siblings: siblings,
            iconName: iconName
        )
    }
}

class NonPropertySpace: Identifiable, ObservableObject, Equatable {

    let name: String
    let iconName: String
    let onLand: () -> Void
    
    init(
        name: String,
        iconName: String
    ) {
        self.name = name
        self.iconName = iconName
    }

  static func ==(lhs: Property, rhs: Property) -> Bool {
        return lhs.name == rhs.name
    }
}

class Start: NonPropertySpace {
    init() {
        super.init(
            name: "Start",
            iconName: "flag.checkered",
            onLand: collectFromBank,
            params: 200
        )
    }
}

class CommunityChest: NonPropertySpace {
    init() {
        super.init(
            name: "Community Chest",
            iconName: "chart.xyaxis.line",
            onLand: draw,
            params: "chest"
        )
    }
}

class Chance: NonPropertySpace {
    init() {
        super.init(
            name: "Travel Agent",
            iconName: "ticket",
            onLand: draw,
            params: "chance"
        )
    }
}

class Jail: NonPropertySpace {
    init() {
        super.init(
            name: "Jail",
            iconName: "tablecells",
            onLand: nil,
            params: nil
        )
    }
}

class GoToJail: NonPropertySpace {
    init() {
        super.init(
            name: "Chance",
            iconName: "hand.raised",
            onLand: goToJail,
            params: nil
        )
    }
}

class FreeParking: NonPropertySpace {
    init() {
        super.init(
            name: "Park",
            iconName: "tree",
            onLand: handleFreeParking,
            params: nil
        )
    }
}

class LuxuryTax: NonPropertySpace {
    init() {
        super.init(
            name: "Out of Policy Claim",
            iconName: "list.bullet.clipboard",
            onLand: payFee,
            params: 75
        )
    }
}

class IncomeTax: NonPropertySpace {
    init() {
        super.init(
            name: "Data Corruption",
            iconName: "externaldrive.badge.xmark",
            onLand: handleIncomeTax,
            params: nil
        )
    }
}


class BuildableProperty: Property {
    @Published var numberHouses: Int
    let housePrice: Int
    let hotelPrice: Int
    let sellHouseFor: Int
    let sellHotelFor: Int
    @Published var hasHotel: Bool
    let housingRates: [Int]
    let hotelRate: Int
    let iconName: String
    
    init(
        name: String,
        isMortgaged: Bool = false,
        iconName: String,
        mortgageValue: Int = 0,
        unMortgageCost: Int = 0,
        baseRent: Int = 0,
        siblings: [Property] = [],
        numberHouses: Int = 0,
        hasHotel: Bool = false,
        housingRates: [Int] = [],
        hotelRate: Int = 0,
        housePrice: Int = 0,
        hotelPrice: Int = 0,
        sellHouseFor: Int = 0,
        sellHotelFor: Int = 0
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
            isMortgaged: isMortgaged,
            mortgageValue: mortgageValue,
            unMortgageCost: unMortgageCost,
            baseRent: baseRent,
            siblings: siblings,
            iconName: iconName
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
        
        if numberHouses < 4 {
            numberHouses += 1
        } else {
            hasHotel = true
        }
        
        owner.money -= (numberHouses < 4 ? housePrice : hotelPrice)
    }
    
    func sellBuilding() {
        guard let owner = owner else {
            return
        }
        
        guard !isMortgaged else {
            return
        }
        
        if hasHotel {
            hasHotel = false
        } else if numberHouses > 0 {
            numberHouses -= 1
        } else {
            return
        }
        
        owner.money += (hasHotel ? sellHotelFor : sellHouseFor)
    }
}

class Utility: Property {
    init(name: String, siblings: [Property] = [],
         iconName: String) {
        super.init(
            name: name,
            isMortgaged: false,
            mortgageValue: 0,
            unMortgageCost: 0,
            baseRent: 0, // Set the appropriate default value
            siblings: siblings,
            iconName: iconName
        )
    }
}

func assignSiblings(to properties: [Any]) -> [Property] {
    var flatList: [Property] = []
    
    for property in properties {
        // Check if the item is of type Property
        if let property = property as? Property {
            // Filter the properties to find siblings with the same group
            property.siblings = properties.compactMap { $0 as? Property }
                .filter { $0.group == property.group && $0 !== property }
            
            // Append the property to the flat list
            flatList.append(property)
        }
    }
    
    return flatList
}


func siblingsOwned(property: Property, owner: Player) -> (unownedProperties: [String], ownedProperties: [String]) {
    var unownedProperties: [String] = []
    var ownedProperties: [String] = [property.name]
    
    for sibling in property.siblings {
        if sibling.owner == nil {
            unownedProperties.append(sibling.name)
        } else if sibling.owner?.id == owner.id {
            ownedProperties.append(sibling.name)
        } else {
            unownedProperties.append(sibling.name)
        }
    }
    
    return (unownedProperties, ownedProperties)
}
