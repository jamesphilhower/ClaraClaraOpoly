import SwiftUI
struct PropertyCardView: View {
    let property: Property
    
    var body: some View {
        VStack(spacing: 4) {
            
            Image(systemName: property.iconName)
                .font(.system(size: 22))
                .foregroundColor(property.color)
                .frame(height: 40)
                .padding( 8)
            
            Text(!property.isMortgaged ? "$\(property.purchasePrice)" : "$\(property.unMortgageCost)")
                .font(.system(size: 10))
                .foregroundColor(!property.isMortgaged ? .black: .red)
            
            Spacer()
        }
        .padding(8)
        .frame(width: 50, height: 75)
        .clipped()
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.white)
                .overlay(
                    Group{
                        if property.isMortgaged {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.pink.opacity(0.2))
                                .padding(2)
                        }
                        if !property.isMortgaged {
                            RoundedRectangle(cornerRadius: 5)
                                .strokeBorder(property.color, lineWidth: 1)
                                .padding(2)
                        }
                    }
                )
        )
        .shadow(radius: 3)
    }
}


struct DetailedPropertyCardView: View {
    let property: Property
    
    var body: some View {
        VStack(spacing: 4) {
            Spacer(minLength: 20)
            Text("\(property.name)")
                .font(.system(size: 14))
                .foregroundColor(.black)
            Image(systemName: property.iconName)
                .font(.system(size: 35))
                .foregroundColor(property.color)
            Spacer()
            let propertyOwner = property.owner
            let (unownedProperties, ownedProperties) = siblingsOwned(property: property, owner: propertyOwner!)
            
            if property.isMortgaged {
                Text("Mortgaged").font(.system(size: 35)).foregroundColor(.red).padding(.bottom, 30)
                Text("Unmortgage for $\(property.unMortgageCost)").font(.system(size: 20)).foregroundColor(.red)
                Spacer()
                Spacer()
            }
            else if let _ = property as? Railroad {
                HStack {
                    Icons.trainEnd
                        .foregroundColor(unownedProperties.contains("R4") ? .gray : .green)
                    Icons.trainMid
                        .foregroundColor(unownedProperties.contains("R2") ? .gray : .green)
                    Icons.trainMid
                        .foregroundColor(unownedProperties.contains("R3") ? .gray : .green)
                    Icons.trainFront
                        .foregroundColor(unownedProperties.contains("R1") ? .gray : .green)
                }
                Spacer()
                HStack{
                    Text("Rent:")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    Spacer()
                }.padding(.bottom, 10)
                
                ForEach(1..<5) { i in
                    HStack{
                        Text("For \(i) car\(i == 1 ? " owned" : "s   \"")")
                            .font(.system(size:12))
                            .foregroundColor(ownedProperties.count == i  ? .green : .gray)
                        Spacer()
                        Text("\([0, 25, 50, 100, 200][i])")
                            .font(.system(size:12))
                            .foregroundColor(ownedProperties.count == i  ? .green : .gray)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(ownedProperties.count == i ? Color.green.opacity(0.1) : Color.clear)
                            .padding(-3)
                    )
                }
                
                
            }
            
            else if let buildableProperty = property as? BuildableProperty {
                PropertiesInSetIconView(ownedProperties: ownedProperties, unownedProperties: unownedProperties)
                HStack {
                    Text("Rent:")
                        .font(.system(size: 12))
                        .foregroundColor(buildableProperty.numberHouses == 0 ? .green : .gray)
                    Spacer()
                    Text("\(buildableProperty.baseRent)")
                        .font(.system(size: 12))
                        .foregroundColor(buildableProperty.numberHouses == 0 ? .green : .gray)
                }.background(RoundedRectangle(cornerRadius: 10).fill(buildableProperty.numberHouses == 0 ?Color.green.opacity(0.1): Color.clear).padding(-3))
                
                ForEach(1..<5) { i in
                    HStack{
                        ForEach(1..<i+1) { _ in
                            Image(systemName: "house")
                                .font(.system(size:9))
                                .foregroundColor(buildableProperty.numberHouses == i ? .green : .gray)
                        }
                        Spacer()
                        Text("\(buildableProperty.housingRates[i])")
                            .font(.system(size:12))
                            .foregroundColor(buildableProperty.numberHouses == i && buildableProperty.hasHotel == false ? .green : .gray)
                    }
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(buildableProperty.numberHouses == i ? Color.green.opacity(0.1) : Color.clear)
                        .padding(-3))
                }
                
                //                HStack (spacing: 2){
                //                    Image(systemName: "house").font(.system(size:9)).foregroundColor(buildableProperty.numberHouses == 1 ? .green : .gray)
                //                    Spacer()
                //                    Text("\(buildableProperty.housingRates[1])").font(.system(size:12)).foregroundColor(buildableProperty.numberHouses == 1 && buildableProperty.hasHotel == false ? .green : .gray)
                //                }.background(RoundedRectangle(cornerRadius: 10).fill(buildableProperty.numberHouses == 1 ?Color.green.opacity(0.1): Color.clear).padding(-3))
                //
                //                HStack (spacing: 2){
                //                    Image(systemName: "house").font(.system(size:9)).foregroundColor(buildableProperty.numberHouses == 2 ? .green : .gray)
                //                    Image(systemName: "house").font(.system(size:9)).foregroundColor(buildableProperty.numberHouses == 2 ? .green : .gray)
                //                    Spacer()
                //                    Text("\(buildableProperty.housingRates[2])").font(.system(size:12)).foregroundColor(buildableProperty.numberHouses == 2 ? .green : .gray)
                //                }.background(RoundedRectangle(cornerRadius: 10).fill(buildableProperty.numberHouses == 2 ?Color.green.opacity(0.1): Color.clear).padding(-3))
                //                HStack (spacing: 2){
                //                    Image(systemName: "house").font(.system(size:9)).foregroundColor(buildableProperty.numberHouses == 3 ? .green : .gray)
                //                    Image(systemName: "house").font(.system(size:9)).foregroundColor(buildableProperty.numberHouses == 3 ? .green : .gray)
                //                    Image(systemName: "house").font(.system(size:9)).foregroundColor(buildableProperty.numberHouses == 3 ? .green : .gray)
                //                    Spacer()
                //                    Text("\(buildableProperty.housingRates[3])").font(.system(size:12)).foregroundColor(buildableProperty.numberHouses == 3 ? .green : .gray)
                //                }.background(RoundedRectangle(cornerRadius: 10).fill(buildableProperty.numberHouses == 3 ?Color.green.opacity(0.1): Color.clear).padding(-3))
                //                HStack (spacing: 2){
                //                    Image(systemName: "house").font(.system(size:9)).foregroundColor(buildableProperty.numberHouses == 4 ? .green : .gray)
                //                    Image(systemName: "house").font(.system(size:9)).foregroundColor(buildableProperty.numberHouses == 4 ? .green : .gray)
                //                    Image(systemName: "house").font(.system(size:9)).foregroundColor(buildableProperty.numberHouses == 4 ? .green : .gray)
                //                    Image(systemName: "house").font(.system(size:9)).foregroundColor(buildableProperty.numberHouses == 4 ? .green : .gray)
                //                    Spacer()
                //                    Text("\(buildableProperty.housingRates[4])").font(.system(size:12)).foregroundColor(buildableProperty.numberHouses == 4 ? .green : .gray)
                //                }.background(RoundedRectangle(cornerRadius: 10).fill(buildableProperty.numberHouses == 4 ?Color.green.opacity(0.1): Color.clear).padding(-3))
                //
                HStack (spacing: 2){
                    Image(systemName: "house.lodge").font(.system(size:11))
                        .foregroundColor(buildableProperty.hasHotel ? .green : .gray)
                    Spacer()
                    Text("\(buildableProperty.hotelRate)").font(.system(size:12)).foregroundColor(buildableProperty.isMortgaged == false && buildableProperty.hasHotel ? .green : .gray)
                    
                }.background(RoundedRectangle(cornerRadius: 10).fill(buildableProperty.hasHotel ?Color.green.opacity(0.1): Color.clear).padding(-3))
            } else if let _ = property as? Utility{
                HStack {
                    Icons.plug.foregroundColor(unownedProperties.contains("U1") ? .gray : .green)
                    Icons.outlet.foregroundColor(unownedProperties.contains("U2") ? .gray : .green)
                }
            }
            
            if !property.isMortgaged {
                Text("$\(property.purchasePrice)")
                    .font(.system(size: 14))
                    .foregroundColor(.black)
            }
            
            Spacer(minLength: 10)
        }
        .padding(24)
        .frame(width: 225, height: 300) // Set a fixed frame size
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(property.color, lineWidth: 3)
                        .background(RoundedRectangle(cornerRadius: 10).fill(property.isMortgaged ? .pink.opacity(0.2) : .white))
                        .padding(6)
                )
                .shadow(radius: 1)
        )
    }
}
