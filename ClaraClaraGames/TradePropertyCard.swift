import SwiftUI

struct TradePropertyCard: View {
    @ObservedObject var property: Property
    @ObservedObject var currentPlayer: Player
    var isSelected: Bool
    var isPurchasing: Bool
    var toggleSelection: () -> Void
    
    var body: some View {
        VStack {
            HStack { Text(property.name)
                    .foregroundColor(.black)
                (
                    isPurchasing
                    ? Image(systemName: isSelected ?  "cart.fill.badge.minus": "cart.badge.plus").frame(width: 40, height: 40)
                    : Image(systemName: isSelected ? "shippingbox.and.arrow.backward.fill": "shippingbox.and.arrow.backward").frame(width: 40, height: 40)
                )
                .frame(width: 40, height: 40)
            }
            
            Text("Current Rent: \(calculateRent(for: property))")
                .foregroundColor(.gray)
            
            Text("Mortgaged: \(property.isMortgaged ? "Yes" : "No")")
                .foregroundColor(.gray)
            
            let propertyOwner = property.owner
            let (unownedProperties, ownedProperties) = siblingsOwned(property: property, owner: propertyOwner!)
            
            if let _ = property as? Railroad {
                HStack {
                    Icons.trainEnd
                        .foregroundColor(unownedProperties.contains("R1") ? .gray : .green)
                    Icons.trainMid
                        .foregroundColor(unownedProperties.contains("R2") ? .gray : .green)
                    Icons.trainMid
                        .foregroundColor(unownedProperties.contains("R3") ? .gray : .green)
                    Icons.trainFront
                        .foregroundColor(unownedProperties.contains("R4") ? .gray : .green)
                }
            }
            
            else if let buildableProperty = property as? BuildableProperty {
                HStack {
                    if unownedProperties.isEmpty {
                        
                        ForEach(0..<4) { index in
                            if index < buildableProperty.numberHouses {
                                Icons.houseFill.foregroundColor(.green)
                            } else {
                                Icons.house.foregroundColor(.gray)
                            }
                        }
                        if buildableProperty.hasHotel {
                            Icons.hotelFill.foregroundColor(.green)
                        } else {
                            Icons.hotel.foregroundColor(.gray)
                        }
                    }
                    else {
                        PropertiesInSetIconView(ownedProperties: ownedProperties, unownedProperties: unownedProperties)
                    }
                }
            } else if let _ = property as? Utility{
                HStack {
                    Icons.plug.foregroundColor(unownedProperties.contains("U1") ? .gray : .green)
                    Icons.outlet.foregroundColor(unownedProperties.contains("U2") ? .gray : .green)
                }
            }
        }
        .padding()
        .cornerRadius(10)
        .border(property.isMortgaged ? Color.red : Color.gray, width: 3)
        .background(Color.white)
        .onTapGesture {
            toggleSelection()
        }
        
    }
}
