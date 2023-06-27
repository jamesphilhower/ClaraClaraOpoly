import SwiftUI




enum PropertyError: Error {
    case noOwner
    case insufficientFunds
    case alreadyMortgaged
}

class PositiveCard {
    var icon = "gift"
}

class InsufficientMoney {
    var icon = "creditcard.trianglebadge"
}

class getOutOfJail {
    var icon = "giftcard"
}

class BoardSpace {
    let name: String
    let iconName: String
    let color: Color
    let group: String
    
    init(name: String, iconName: String, color: Color, group: String = "NonProperty")
    {
        self.name = name
        self.iconName = iconName
        self.color = color
        self.group = group
    }
}

class Property: BoardSpace, Identifiable, ObservableObject, Equatable {
    @Published var isMortgaged: Bool
    let mortgageValue: Int
    let unMortgageCost: Int
    let purchasePrice: Int
    @Published var owner: Player?
    let baseRent: Int
    @Published var siblings: [Property] = []
    
    init(
        name: String,
        purchasePrice: Int,
        group: String,
        isMortgaged: Bool = false,
        mortgageValue: Int = 0,
        unMortgageCost: Int = 0,
        baseRent: Int = 0,
        iconName: String,
        color: Color
    ) {
        self.purchasePrice = purchasePrice
        self.isMortgaged = isMortgaged
        self.mortgageValue = mortgageValue
        self.unMortgageCost = unMortgageCost
        self.baseRent = baseRent
        super.init(
            name: name,
            iconName: iconName,
            color: color,
            group: group
        )
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
    init(name: String, isMortgaged: Bool = false,
         iconName: String) {
        super.init(
            name: name,
            purchasePrice: 200,
            group: "rr",
            isMortgaged: isMortgaged,
            mortgageValue: 0,
            unMortgageCost: 0,
            baseRent: 25,
            iconName: iconName,
            color: .black
        )
    }
}

class NonPropertySpace: BoardSpace {
    let onLand: (Player)async -> Void
    
    init(
        name: String,
        iconName: String,
        onLand: @escaping (Player)async -> Void,
        color: Color
    ) {
        self.onLand = onLand
        super.init(
            name: name,
            iconName: iconName,
            color: color
        )
    }
}

class Start: NonPropertySpace {
    init() {
        super.init(
            name: "Start",
            iconName: "flag.checkered",
            onLand: { player in
                 player.collectFromBank(200)
            },
            color: .red
        )
    }
}

class CommunityChest: NonPropertySpace {
    init() {
        super.init(
            name: "Community Chest",
            iconName: "chart.xyaxis.line",
            onLand: { player in
                await player.draw("chest")
            },
            color: .mint
        )
    }
}

class Chance: NonPropertySpace {
    init() {
        super.init(
            name: "Travel Agent",
            iconName: "ticket",
            onLand: { player in
                await player.draw("chance")
            },
            color: .mint
        )
    }
}

func doNothing(_ player: Player) {}
class Jail: NonPropertySpace {
    init() {
        super.init(
            name: "Jail",
            iconName: "tablecells",
            onLand: doNothing,
            color: .blue
        )
    }
}

class GoToJail: NonPropertySpace {
    init() {
        super.init(
            name: "Chance",
            iconName: "hand.raised",
            onLand: { player in
                player.goToJail()
            },
            color: .blue
        )
    }
}

class FreeParking: NonPropertySpace {
    init() {
        super.init(
            name: "Park",
            iconName: "tree",
            onLand: { player in
                player.handleFreeParking()
            },
            color: .green
        )
    }
}

class LuxuryTax: NonPropertySpace {
    init() {
        super.init(
            name: "Out of Policy Claim",
            iconName: "list.bullet.clipboard",
            onLand: { player in
                player.payFee(75)
            },
            color: .red
        )
    }
}

class IncomeTax: NonPropertySpace {
    init() {
        super.init(
            name: "Data Corruption",
            iconName: "externaldrive.badge.xmark",
            onLand: { player in
                player.handleIncomeTax()
            },
            color: .red
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
    init(name: String,
         iconName: String) {
        super.init(
            name: name,
            purchasePrice: 150,
            group: "utilities",
            isMortgaged: false,
            mortgageValue: 0,
            unMortgageCost: 0,
            baseRent: 0, // Set the appropriate default value
            iconName: iconName,
            color: .gray
        )
    }
}

func assignSiblings(to spaces: [Any]) -> ([BoardSpace], [Property]) {
    var spaceResult: [BoardSpace] = []
    var properties: [Property] = []

    for space in spaces {
        print("What")
        // Check if the item is of type Property
        if let property = space as? Property {
            // Filter the properties to find siblings with the same group
            property.siblings = spaces.compactMap { $0 as? Property }
                .filter { $0.group == property.group && $0 !== property }
            
            // Append the property to the flat list
            properties.append(property)
        }
        if let space = space as? BoardSpace {
            spaceResult.append(space)
        }
    }
    
    return (spaceResult, properties)
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
