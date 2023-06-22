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
    
    // screwdriver wrench.adjustable hammer
    //  poweroutlet.type.g poweroutlet.type.a  batteryblock (any bolt)
    // tent house.lodge house.and.flag house building building.2
    // wifi  antenna.radiowaves cellularbars wifi.router simcard personalhotspot

    var iconName: String {
        switch self {
        // Side 1
        case .brown:
            // scooter bicycle
            return "house.fill"
        case .lightBlue:
            // cablecar tram.fill.tunnel bus
            return "house.fill"
        // Side 2
        case .pink:
            // graudationcap backpack text.book.closed
            return "house.fill"
        case .orange:
            // magazine newspaper radio
            return "house.fill"
        // Side 3
        case .red:
            // cross
            // syringe allergens facemask
            return "house.fill"
        case .yellow:
            // airplane
            // airplane.departure airplane airplane.arrival
            return "house.fill"
        // Side 4
        case .green:
            // antenna.radiowaves
            // cloud wifi cellularbars
            return "house.fill"
        case .darkBlue:
            //
            // crown building.columns
            return "house.fill"
        }
    }
    
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


//let propertyGroups: [PropertyGroup: [BuildableProperty]] = [
//    .lightBlue: lightBlueGroup,
//    .pink: pinkGroup,
//    .orange: orangeGroup,
//    // Add other property groups here...
//]
//
//// Assign the icons to the properties
//for (group, properties) in propertyGroups {
//    let iconName = group.iconName
//    for property in properties {
//        property.iconName = iconName
//    }
//}

//// Combine all the properties into the final array
//let properties = lightBlueGroup + pinkGroup + orangeGroup + buildables
//propertiesData.properties = properties



class Property: Identifiable, ObservableObject, Equatable {
    let name: String
    let icon: any View
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
        icon: some View
    ) {
        self.name = name
        self.isMortgaged = isMortgaged
        self.mortgageValue = mortgageValue
        self.unMortgageCost = unMortgageCost
        self.baseRent = baseRent
        self.siblings = siblings
        self.icon = icon
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
             icon: some View) {
            super.init(
                name: name,
                isMortgaged: isMortgaged,
                mortgageValue: 0,
                unMortgageCost: 0,
                baseRent: 25,
                siblings: siblings,
                icon: icon
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
    let iconDimensions: (CGFloat, CGFloat)
    let buildableIcon: Image
    
    init(
        name: String,
        isMortgaged: Bool = false,
        icon:  (Image, CGFloat, CGFloat),
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
        self.iconDimensions = (icon.1, icon.2)
        self.buildableIcon = (icon.0)
        super.init(
            name: name,
            isMortgaged: isMortgaged,
            mortgageValue: mortgageValue,
            unMortgageCost: unMortgageCost,
            baseRent: baseRent,
            siblings: siblings,
            icon: icon.0
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
         icon: some View) {
            super.init(
                name: name,
                isMortgaged: false,
                mortgageValue: 0,
                unMortgageCost: 0,
                baseRent: 0, // Set the appropriate default value
                siblings: siblings,
                icon: icon
            )
        }
}
func assignSiblings(to arrays: [[Property]]) -> [Property] {
    var flatList: [Property] = []
    
    for array in arrays {
        for property in array {
            property.siblings = array.filter { $0 !== property }
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
