import SwiftUI

class PropertiesData: ObservableObject {
    @Published var properties: [Property] = []
    @Published var homeTransactions: Int = 0
    var spaces: [BoardSpace] = []
    
    private func assignSiblingsAndSplitSpaceTypes(_ spaces: [Any]) -> ([BoardSpace], [Property]) {
        var spaceResult: [BoardSpace] = []
        var properties: [Property] = []

        for space in spaces {
            if let property = space as? Property {
                property.siblings = spaces.compactMap { $0 as? Property }
                    .filter { $0.group == property.group && $0 !== property }
                properties.append(property)
            }
            if let space = space as? BoardSpace {
                spaceResult.append(space)
            }
        }
        
        return (spaceResult, properties)
    }
    
    func createData()-> ([BoardSpace], [Property]) {
        return assignSiblingsAndSplitSpaceTypes(propertyData)
    }
    
    init(){
        let data = createData()
        let spaces = data.0
        self.spaces = spaces
        let properties = data.1
        self.properties = properties
        // Todo Should throw or do something if not equal to 40
        print("Spaces", self.spaces.count)
    }
}

// Todo fill in all the correct values
// The zero in housing rates is for 0 index help
private let propertyData = [
    Start(),
    BuildableProperty(name: "Scooter Shop"    , purchasePrice: 60 , group: "brown"       , iconName: "scooter"           ,mortgageValue: 30 , unMortgageCost: 33 , baseRent: 2 ,  housingRates: [0, 30, 90, 160, 250],   hotelRate: 300 , housePrice: 50 , hotelPrice: 50 , sellHouseFor: 25 , sellHotelFor: 25 , color: .brown),
    CommunityChest(),
    BuildableProperty(name: "Bike Shop"        , purchasePrice: 60 , group: "brown"       , iconName: "bicycle"          ,mortgageValue: 30 , unMortgageCost: 33 , baseRent: 4 ,  housingRates: [0, 20, 60, 180, 320],   hotelRate: 450 , housePrice: 50 , hotelPrice: 50 , sellHouseFor: 25 , sellHotelFor: 25 , color: .brown),
    IncomeTax(),
    Railroad(name: "R1"                       , iconName: "train.side.front.car"),
    BuildableProperty(name: "Subway Station"   , purchasePrice: 100, group: "lightBlue"   , iconName: "tram.fill.tunnel" ,mortgageValue: 50 , unMortgageCost: 55 , baseRent: 6 ,  housingRates: [0, 30, 90, 270, 400],   hotelRate: 550 , housePrice: 50 , hotelPrice: 50 , sellHouseFor: 25 , sellHotelFor: 25 , color: .cyan),
    Chance(),
    BuildableProperty(name: "Bus Station"      , purchasePrice: 100, group: "lightBlue"   , iconName: "bus"              ,mortgageValue: 50 , unMortgageCost: 55 , baseRent: 6 ,  housingRates: [0, 30, 90, 270, 400],   hotelRate: 550 , housePrice: 50 , hotelPrice: 50 , sellHouseFor: 25 , sellHotelFor: 25 , color: .cyan),
    BuildableProperty(name: "Train Station"    , purchasePrice: 120, group: "lightBlue"   , iconName: "cablecar"         ,mortgageValue: 60 , unMortgageCost: 66 , baseRent: 8 ,  housingRates: [0, 40, 100, 300, 450],  hotelRate: 600 , housePrice: 50 , hotelPrice: 50 , sellHouseFor: 25 , sellHotelFor: 25 , color: .cyan),
    Jail(),
    BuildableProperty(name: "Graduation"       , purchasePrice: 140, group: "pink"        , iconName: "graduationcap"    ,mortgageValue: 70, unMortgageCost: 77, baseRent: 10,    housingRates: [0, 50, 150, 450, 625],  hotelRate: 750 , housePrice: 100, hotelPrice: 100, sellHouseFor: 50 , sellHotelFor: 50 , color: .pink),
    Utility(name: "The Outlets"                , iconName: "poweroutlet.type.b"),
    BuildableProperty(name: "Backpack"         , purchasePrice: 140, group: "pink"        , iconName: "backpack"         ,mortgageValue: 70, unMortgageCost: 77, baseRent: 10,    housingRates: [0, 50, 150, 450, 625],  hotelRate: 750 , housePrice: 100, hotelPrice: 100, sellHouseFor: 50 , sellHotelFor: 50 , color: .pink),
    BuildableProperty(name: "Book Store"       , purchasePrice: 160, group: "pink"        , iconName: "text.book.closed" ,mortgageValue: 80, unMortgageCost: 88, baseRent: 12,    housingRates: [0, 60, 180, 500, 700],  hotelRate: 900 , housePrice: 100, hotelPrice: 100, sellHouseFor: 50 , sellHotelFor: 50 , color: .pink),
    Railroad(name: "R2"                       , iconName: "train.side.middle.car"),
    BuildableProperty(name: "Departures"       , purchasePrice: 180, group: "orange"      , iconName: "airplane.departure",mortgageValue: 90, unMortgageCost: 99, baseRent: 14,   housingRates: [0, 70, 200, 550, 750],  hotelRate: 950 , housePrice: 100, hotelPrice: 100, sellHouseFor: 50 , sellHotelFor: 50 , color: .orange),
    CommunityChest(),
    BuildableProperty(name: "Airplane"         , purchasePrice: 180, group: "orange"      , iconName: "airplane"         ,mortgageValue: 90, unMortgageCost: 99, baseRent: 14,    housingRates: [0, 70, 200, 550, 750],  hotelRate: 950 , housePrice: 100, hotelPrice: 100, sellHouseFor: 50 , sellHotelFor: 50 , color: .orange),
    BuildableProperty(name: "Arrivals"         , purchasePrice: 200, group: "orange"      , iconName: "airplane.arrival" ,mortgageValue: 100, unMortgageCost: 110, baseRent: 16,  housingRates: [0, 80, 220, 600, 800],  hotelRate: 1000, housePrice: 100, hotelPrice: 100, sellHouseFor: 50 , sellHotelFor: 50 , color: .orange),
    FreeParking(),
    BuildableProperty(name: "Gossip Media"     , purchasePrice: 220, group: "red"         , iconName: "magazine"         ,mortgageValue: 110, unMortgageCost: 121, baseRent: 18,  housingRates: [0, 90, 250, 700, 875],  hotelRate: 1050 , housePrice: 150, hotelPrice: 150, sellHouseFor: 75 , sellHotelFor: 75 , color: .red),
    Chance(),
    BuildableProperty(name: "News Media"       , purchasePrice: 220, group: "red"         , iconName: "newspaper"        ,mortgageValue: 110, unMortgageCost: 121, baseRent: 18,  housingRates: [0, 90, 250, 700, 875],  hotelRate: 1050 , housePrice: 150, hotelPrice: 150, sellHouseFor: 75 , sellHotelFor: 75 , color: .red),
    BuildableProperty(name: "Talk Radio"       , purchasePrice: 240, group: "red"         , iconName: "radio"            ,mortgageValue: 120, unMortgageCost: 132, baseRent: 20,  housingRates: [0, 100, 300, 750, 925],  hotelRate: 1100, housePrice: 150, hotelPrice: 150, sellHouseFor: 75 , sellHotelFor: 75 , color: .red),
    Railroad(name: "R3"                       , iconName: "train.side.middle.car"),
    BuildableProperty(name: "Cell Towers"      , purchasePrice: 260, group: "yellow"      , iconName: "cellularbars"     ,mortgageValue: 130, unMortgageCost: 143, baseRent: 22,  housingRates: [0, 110, 330, 800, 975],  hotelRate: 1150, housePrice: 150, hotelPrice: 150, sellHouseFor: 75 , sellHotelFor: 75 , color: .yellow),
    Utility(name: "The Plug"                  , iconName: "powerplug"),
    BuildableProperty(name: "Wifi"             , purchasePrice: 260, group: "yellow"      , iconName: "wifi"             ,mortgageValue: 130, unMortgageCost: 143, baseRent: 22,  housingRates: [0, 110, 330, 800, 975],  hotelRate: 1150, housePrice: 150, hotelPrice: 150, sellHouseFor: 75 , sellHotelFor: 75 , color: .yellow),
    BuildableProperty(name: "The Cloud"        , purchasePrice: 280, group: "yellow"      , iconName: "cloud"            ,mortgageValue: 140, unMortgageCost: 154, baseRent: 24,  housingRates: [0, 120, 360, 850, 1025], hotelRate: 1200, housePrice: 150, hotelPrice: 150, sellHouseFor: 75 , sellHotelFor: 75 , color: .yellow),
    GoToJail(),
    BuildableProperty(name: "Vaccines"         , purchasePrice: 300, group: "green"       , iconName: "syringe"          ,mortgageValue: 150, unMortgageCost: 165, baseRent: 26,  housingRates: [0, 130, 390, 900, 1100], hotelRate: 1275, housePrice: 150, hotelPrice: 150, sellHouseFor: 100, sellHotelFor: 100, color: .green),
    BuildableProperty(name: "Allergies"        , purchasePrice: 300, group: "green"       , iconName: "allergens"        ,mortgageValue: 150, unMortgageCost: 165, baseRent: 26,  housingRates: [0, 130, 390, 900, 1100], hotelRate: 1275, housePrice: 150, hotelPrice: 150, sellHouseFor: 100, sellHotelFor: 100, color: .green),
    CommunityChest(),
    BuildableProperty(name: "Facemask"         , purchasePrice: 320, group: "green"       , iconName: "facemask"         ,mortgageValue: 160, unMortgageCost: 176, baseRent: 28,  housingRates: [0, 150, 450, 1000, 1200], hotelRate: 1400, housePrice: 150, hotelPrice: 150, sellHouseFor: 100 , sellHotelFor: 100,color: .green),
    Railroad(name: "R4"                       , iconName: "train.side.rear.car"),
    Chance(),
    BuildableProperty(name: "The Blue House"   , purchasePrice: 350, group: "darkBlue"    , iconName: "crown"            ,mortgageValue: 175, unMortgageCost: 193, baseRent: 35,  housingRates: [0, 175, 500, 1100, 1300], hotelRate: 1500, housePrice: 200, hotelPrice: 200, sellHouseFor: 100, sellHotelFor: 100, color: .blue),
    LuxuryTax(),
    BuildableProperty(name: "Congress"         , purchasePrice: 400, group: "darkBlue"    , iconName: "building.columns" ,mortgageValue: 200, unMortgageCost: 220, baseRent: 50,  housingRates: [0, 200, 600, 1400, 1700], hotelRate: 2000, housePrice: 200, hotelPrice: 200, sellHouseFor: 100, sellHotelFor: 100, color: .blue)
] as [Any]
