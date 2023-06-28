import SwiftUI

enum PropertyError: Error {
    case noOwner
    case insufficientFunds
    case alreadyMortgaged
}

class Property: BoardSpace, Identifiable, Equatable {
    @Published var isMortgaged: Bool
    @Published var owner: Player?
    @Published var siblings: [Property] = []

    let mortgageValue: Int
    let unMortgageCost: Int
    let purchasePrice: Int
    let baseRent: Int
    
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
    
    static func ==(lhs: Property, rhs: Property) -> Bool {
        return lhs.name == rhs.name &&
        lhs.isMortgaged == rhs.isMortgaged &&
        lhs.mortgageValue == rhs.mortgageValue &&
        lhs.unMortgageCost == rhs.unMortgageCost &&
        lhs.owner == rhs.owner &&
        lhs.baseRent == rhs.baseRent &&
        lhs.siblings == rhs.siblings
    }
}

// Todo this should maybe be a method on property
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
