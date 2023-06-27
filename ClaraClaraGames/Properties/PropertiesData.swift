import SwiftUI

class PropertiesData: ObservableObject {
    @Published var properties: [Property] = []
    var spaces: [BoardSpace] = []
    
    func createData()-> ([BoardSpace], [Property]) {
        
        let propertyInit = [
            Start(),
            BuildableProperty(name: "Scooter Shop", purchasePrice:     60  , group: "brown", iconName: "scooter",mortgageValue: 100, unMortgageCost: 110, baseRent: 2,  housingRates: [10, 30, 90, 160, 250], hotelRate: 300, housePrice: 50, hotelPrice: 200, sellHouseFor: 25, sellHotelFor: 100, color: .brown),
            CommunityChest(),
            BuildableProperty(name: "Bike Shop", purchasePrice:    60   , group: "brown", iconName: "bicycle",mortgageValue: 100, unMortgageCost: 110, baseRent: 4,  housingRates: [20, 60, 180, 320, 450], hotelRate: 450, housePrice: 50, hotelPrice: 200, sellHouseFor: 25, sellHotelFor: 100, color: .brown),
            IncomeTax(),
            Railroad(name: "R1", iconName: "train.side.front.car"),
            BuildableProperty(name: "Subway Station", purchasePrice:    100   , group: "lightBlue", iconName: "tram.fill.tunnel", mortgageValue: 60, unMortgageCost: 66, baseRent: 6,  housingRates: [2, 10, 30, 90, 160], hotelRate: 250, housePrice: 50, hotelPrice: 50, sellHouseFor: 25, sellHotelFor: 25, color: .cyan),
            Chance(),
            BuildableProperty(name: "Bus Station", purchasePrice:   100    , group: "lightBlue", iconName: "bus", mortgageValue: 60, unMortgageCost: 66, baseRent: 6,  housingRates: [2, 10, 30, 90, 160], hotelRate: 250, housePrice: 50, hotelPrice: 50, sellHouseFor: 25, sellHotelFor: 25, color: .cyan),
            BuildableProperty(name: "Train Station", purchasePrice:   120    , group: "lightBlue", iconName: "cablecar", mortgageValue: 100, unMortgageCost: 110, baseRent: 10,  housingRates: [6, 30, 90, 270, 400], hotelRate: 550, housePrice: 50, hotelPrice: 50, sellHouseFor: 25, sellHotelFor: 25, color: .cyan),
            Jail(),
            BuildableProperty(name: "Graduation", purchasePrice:   140    , group: "pink", iconName: "graduationcap", mortgageValue: 100, unMortgageCost: 110, baseRent: 10,  housingRates: [6, 30, 90, 270, 400], hotelRate: 550, housePrice: 50, hotelPrice: 50, sellHouseFor: 25, sellHotelFor: 25, color: .pink),
            Utility(name: "The Outlets", iconName: "poweroutlet.type.b"),
            BuildableProperty(name: "Backpack", purchasePrice:   140    , group: "pink", iconName: "backpack" , mortgageValue: 100, unMortgageCost: 110, baseRent: 10,  housingRates: [6, 30, 90, 270, 400], hotelRate: 550, housePrice: 50, hotelPrice: 50, sellHouseFor: 25, sellHotelFor: 25, color: .pink),
            BuildableProperty(name: "Book Store", purchasePrice:  160     , group: "pink", iconName: "text.book.closed", mortgageValue: 120, unMortgageCost: 132, baseRent: 12,  housingRates: [8, 40, 100, 300, 450], hotelRate: 600, housePrice: 50, hotelPrice: 50, sellHouseFor: 25, sellHotelFor: 25, color: .pink),
            Railroad(name: "R2", iconName: "train.side.middle.car"),
            BuildableProperty(name: "Departures", purchasePrice:   180    , group: "orange", iconName: "airplane.departure", mortgageValue: 140, unMortgageCost: 154, baseRent: 14,  housingRates: [10, 50, 150, 450, 625], hotelRate: 750, housePrice: 100, hotelPrice: 100, sellHouseFor: 50, sellHotelFor: 50, color: .orange),
            CommunityChest(),
            BuildableProperty(name: "Airplane", purchasePrice:   180    , group: "orange", iconName: "airplane", mortgageValue: 140, unMortgageCost: 154, baseRent: 14,  housingRates: [10, 50, 150, 450, 625], hotelRate: 750, housePrice: 100, hotelPrice: 100, sellHouseFor: 50, sellHotelFor: 50, color: .orange),
            BuildableProperty(name: "Arrivals", purchasePrice:   200    , group: "orange", iconName: "airplane.arrival", mortgageValue: 160, unMortgageCost: 176, baseRent: 16,  housingRates: [12, 60, 180, 500, 700], hotelRate: 900, housePrice: 100, hotelPrice: 100, sellHouseFor: 50, sellHotelFor: 50, color: .orange),
            FreeParking(),
            BuildableProperty(name: "Gossip Media", purchasePrice:   220    , group: "red", iconName: "magazine", mortgageValue: 220, unMortgageCost: 242, baseRent: 18,  housingRates: [14, 70, 200, 550, 750], hotelRate: 950, housePrice: 150, hotelPrice: 150, sellHouseFor: 75, sellHotelFor: 75, color: .red),
            Chance(),
            BuildableProperty(name: "News Media", purchasePrice:   220    , group: "red", iconName: "newspaper", mortgageValue: 220, unMortgageCost: 242, baseRent: 18,  housingRates: [14, 70, 200, 550, 750], hotelRate: 950, housePrice: 150, hotelPrice: 150, sellHouseFor: 75, sellHotelFor: 75, color: .red),
            BuildableProperty(name: "Talk Radio", purchasePrice:    240   , group: "red", iconName: "radio", mortgageValue: 240, unMortgageCost: 264, baseRent: 20,  housingRates: [16, 80, 220, 600, 800], hotelRate: 1000, housePrice: 150, hotelPrice: 150, sellHouseFor: 75, sellHotelFor: 75, color: .red),
            Railroad(name: "R3", iconName: "train.side.middle.car"),
            BuildableProperty(name: "Cell Towers", purchasePrice:   260    , group: "yellow", iconName: "cellularbars", mortgageValue: 160, unMortgageCost: 180, baseRent: 22,  housingRates: [14, 50, 150, 450, 625], hotelRate: 750, housePrice: 100, hotelPrice: 200, sellHouseFor: 50, sellHotelFor: 100, color: .yellow),
            Utility(name: "The Plug", iconName: "powerplug"),
            BuildableProperty(name: "Wifi", purchasePrice:  260     , group: "yellow", iconName: "wifi", mortgageValue: 160, unMortgageCost: 180, baseRent: 22,  housingRates: [14, 50, 150, 450, 625], hotelRate: 750, housePrice: 100, hotelPrice: 200, sellHouseFor: 50, sellHotelFor: 100, color: .yellow),
            BuildableProperty(name: "The Cloud", purchasePrice:  280     , group: "yellow", iconName: "cloud", mortgageValue: 160, unMortgageCost: 180, baseRent: 24,  housingRates: [16, 60, 180, 500, 700], hotelRate: 900, housePrice: 100, hotelPrice: 200, sellHouseFor: 50, sellHotelFor: 100, color: .yellow),
            GoToJail(),
            BuildableProperty(name: "Vaccines", purchasePrice:   300    , group: "green", iconName: "syringe", mortgageValue: 200, unMortgageCost: 220, baseRent: 26,  housingRates: [18, 90, 250, 700, 875], hotelRate: 1050, housePrice: 150, hotelPrice: 200, sellHouseFor: 75, sellHotelFor: 100, color: .green),
            BuildableProperty(name: "Allergies", purchasePrice:  300     , group: "green", iconName: "allergens", mortgageValue: 200, unMortgageCost: 220, baseRent: 26,  housingRates: [18, 90, 250, 700, 875], hotelRate: 1050, housePrice: 150, hotelPrice: 200, sellHouseFor: 75, sellHotelFor: 100, color: .green),
            CommunityChest(),
            BuildableProperty(name: "Facemask", purchasePrice:    320   , group: "green", iconName: "facemask", mortgageValue: 200, unMortgageCost: 220, baseRent: 28,  housingRates: [20, 100, 300, 750, 925], hotelRate: 1100, housePrice: 150, hotelPrice: 200, sellHouseFor: 75, sellHotelFor: 100, color: .green),
            Railroad(name: "R4", iconName: "train.side.rear.car"),
            Chance(),
            BuildableProperty(name: "The Blue House", purchasePrice:   350    , group: "darkBlue", iconName: "crown", mortgageValue: 350, unMortgageCost: 400, baseRent: 35,  housingRates: [35, 175, 500, 1100, 1300], hotelRate: 1500, housePrice: 200, hotelPrice: 200, sellHouseFor: 100, sellHotelFor: 100, color: .blue),
            LuxuryTax(),
            BuildableProperty(name: "Congress", purchasePrice:   400    , group: "darkBlue", iconName: "building.columns", mortgageValue: 100, unMortgageCost: 110, baseRent: 16,  housingRates: [40, 80, 220, 600, 800], hotelRate: 1000, housePrice: 50, hotelPrice: 200, sellHouseFor: 25, sellHotelFor: 100, color: .blue)
        ] as [Any]

        // Add the created properties to your propertiesData object

        let data = assignSiblings(to: propertyInit)
        return data
    }
    
    init(){
        let data = createData()
        let properties = data.1
        let spaces = data.0
        self.properties = properties
        self.spaces = spaces

        print("Spaces", self.spaces.count)
    }
}
