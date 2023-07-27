import SwiftUI

class Utility: Property {
    init(name: String,
         iconName: String) {
        super.init(
            name: name,
            purchasePrice: 150,
            group: "utilities",
            isMortgaged: false,
            mortgageValue: 75,
            unMortgageCost: 83,
            baseRent: 0,
            iconName: iconName,
            color: .gray
        )
    }
}
