import SwiftUI

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
