import SwiftUI

struct ManagePropertiesModal: View {
    @EnvironmentObject var propertiesData: PropertiesData
    @State private var selectedProperty: Property?
    
    @Binding var currentPlayerAction: PlayerActionsType
    @ObservedObject var currentPlayer: Player
    
    var body: some View {
        ZStack {
            Color.green
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        currentPlayerAction = .none
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    .padding()
                }
                
                ScrollView {
                    ForEach(propertiesData.properties) { property in
                        if property.owner == currentPlayer {
                            PropertyCard(property: property,currentPlayer: currentPlayer)
                        }
                    }
                }
            }
        }
    }
}

struct PropertyCard: View {
    @EnvironmentObject var propertiesData: PropertiesData
    @ObservedObject var property: Property
    // This will need to be observable ified like the property was
    @ObservedObject var currentPlayer: Player
    
    var body: some View {
        
        VStack {
            Text(property.name)
                .font(.title)
                .padding(.top, 10)
                .frame(height: 100)
                .padding(.vertical, 10)
                .cornerRadius(10)
            
            if let buildableProperty = property as? BuildableProperty {
                HStack {
                    ForEach(0..<4) { index in
                        Image(systemName: "house.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundColor(index < buildableProperty.numberHouses ? .green: .gray)
                    }
                    
                    
                    Image(systemName: "house.lodge")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor( buildableProperty.hasHotel ? .green: .gray)
                    
                    
                    Button(action: {
                        buildableProperty.buyBuilding()
                    }) {
                        Text("Buy \(buildableProperty.numberHouses < 4 ? "House" : "Hotel")")
                    }
                    .padding(.leading, 10)
                    .disabled(!currentPlayer.hasFundsFor(buildableProperty.numberHouses < 4 ? buildableProperty.housePrice : buildableProperty.hotelPrice) || buildableProperty.isMortgaged)
                    
                    
                    Button(action: {
                        buildableProperty.sellBuilding()
                    }) {
                        Text("Sell \(buildableProperty.hasHotel ? "Hotel" : "House")")
                    }.disabled(buildableProperty.numberHouses == 0)
                        .padding(.leading, 10)
                    
                }
            }
            
            HStack {
                Text("Rent: \(calculateRent(for: property))")
                    .font(.caption)
                    .padding(.bottom, 10)
                if property.isMortgaged {
                    Button(action: {
                        // Unmortgage
                        if currentPlayer.hasFundsFor(property.unMortgageCost) {
                            do {
                                try property.unMortgage()
                            } catch {
                                // Handle error if needed
                            }
                        }
                    }) {
                        Text("Unmortgage for \(property.unMortgageCost)")
                    }
                } else if !(property is BuildableProperty) {
                    Button(action: {
                        do {
                            try property.mortgage()
                        } catch {
                            // Handle error if needed
                        }
                    }) {
                        Text("Mortgage for \(property.mortgageValue)")
                    }
                } else if let buildableProperty = property as? BuildableProperty, buildableProperty.numberHouses == 0 {
                    Button(action: {
                        do {
                            try property.mortgage()
                        } catch {
                            // Handle error if needed
                        }
                    }) {
                        Text("Mortgage for \(property.mortgageValue)")
                    }
                }
            }
            
        }
        .padding()
        .background(property.isMortgaged ? Color.red : Color.white)
        .cornerRadius(10)
        .padding()
    }
}
