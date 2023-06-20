import SwiftUI






struct TradePropertyCard: View {
    @ObservedObject var property: Property
    @ObservedObject var currentPlayer: Player
    var isSelected: Bool
    var toggleSelection: () -> Void
    
    var body: some View {
        VStack {
            Text(property.name)
                .font(.title)
                .foregroundColor(.black)
            
            Text("Current Rent: \(calculateRent(for: property))")
                .foregroundColor(.gray)
            
            Text("Mortgaged: \(property.isMortgaged ? "Yes" : "No")")
                .foregroundColor(.gray)
            
            let propertyOwner = property.owner
            let (unownedProperties, ownedProperties) = siblingsOwned(property: property, owner: propertyOwner!)
            
            if let railroadProperty = property as? Railroad {
                HStack {
                    Icons.trainEnd.0
                        .foregroundColor(unownedProperties.contains("R1") ? .gray : .green)
                    Icons.trainMid.0
                        .foregroundColor(unownedProperties.contains("R2") ? .gray : .green)
                    Icons.trainMid.0
                        .foregroundColor(unownedProperties.contains("R3") ? .gray : .green)
                    Icons.trainFront.0
                        .foregroundColor(unownedProperties.contains("R4") ? .gray : .green)
                }
            }
            
            else if let buildableProperty = property as? BuildableProperty {
                HStack {
                    if unownedProperties.isEmpty {
                        
                        ForEach(0..<4) { index in
                            if index < buildableProperty.numberHouses {
                                Icons.house.0.foregroundColor(.green)
                            } else {
                                Icons.houseFill.0.foregroundColor(.gray)
                            }
                        }
                        Icons.hotelFill.0.foregroundColor(buildableProperty.hasHotel ? .green : .gray)
                    }
                    else {
                        CreateIcons(ownedProperties: ownedProperties, unownedProperties: unownedProperties)
                    }
                    
                }
            } else if let utilityProperty = property as? Utility{
                HStack {
                    Icons.plug.0.foregroundColor(unownedProperties.contains("U1") ? .gray : .green)
                    Icons.outlet.0.foregroundColor(unownedProperties.contains("U2") ? .gray : .green)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: property.isMortgaged ? Color.red : Color.white, radius: 5)
        .onTapGesture {
            toggleSelection()
        }
    }
}

struct CreateIcons: View {
    @EnvironmentObject var propertiesData: PropertiesData

    let ownedProperties: [String]
    let unownedProperties: [String]

    var body: some View {
        let combinedProperties = ownedProperties + unownedProperties
        let sortedProperties = combinedProperties.sorted()

        return HStack {
            ForEach(sortedProperties, id: \.self) { propertyName in
                let currentProperty = propertiesData.properties.first(where: { $0.name == propertyName }) as! BuildableProperty

                
                currentProperty.icon.0
                    .foregroundColor(ownedProperties.contains(currentProperty.name) ? .green : .gray)
                    .frame(width:  currentProperty.icon.2, height: currentProperty.icon.1)
                    .aspectRatio(contentMode: .fit)
            }
        }
    }

}

struct TradeModalView: View {
    
    private func isSelected(property: Property, in array: [Property]) -> Bool {
        array.contains(property)
    }
    
    private func toggleSelection(for property: Property, in array: inout [Property]) {
        if let index = array.firstIndex(of: property) {
            array.remove(at: index)
        } else {
            array.append(property)
        }
    }
    
    // Add your necessary properties and methods for trade handling
    @EnvironmentObject private var diceAnimation: DiceAnimationData
    @EnvironmentObject var propertiesData: PropertiesData
    @EnvironmentObject var playersData: PlayersData
    
    //    @State private var selectedPlayer: Player?
    @State private var tradeAmount: Int = 0
    @State private var propertiesToEndWithOriginalPlayer: [Property] = []
    @State private var propertiesToEndWithSecondPlayer: [Property] = []
    // this should be passed in I believe
    @State private var isShowingConfirmationView = false
    
    @Binding var currentPlayerAction: PlayerActionsType
    @ObservedObject var currentPlayer: Player
    
    @State private var selectedPlayer: Player? {
        didSet {
            print("selectedPlayer didSet:", selectedPlayer?.name ?? "nil")
            propertiesToEndWithOriginalPlayer = propertiesData.properties.filter { property in
                property.owner != nil && property.owner == selectedPlayer
            }
            print("propertiesToEndWithOriginalPlayer:", propertiesToEndWithOriginalPlayer)
        }
    }
    
    //    private func setInitialSelectedPlayer() {
    //        if playersData.players.count == 2 {
    //            let otherPlayers = playersData.players.filter { $0.id != currentPlayer.id }
    //            selectedPlayer = otherPlayers.first
    //        }
    //    }
    //
    //    init(currentPlayerAction: Binding<PlayerActionsType>, currentPlayer: Player) {
    //        self._currentPlayerAction = currentPlayerAction
    //        self.currentPlayer = currentPlayer
    //        setInitialSelectedPlayer()
    //    }
    
    var body: some View {
        
        
        if isShowingConfirmationView {
            TradeConfirmationView(
                selectedPlayer: selectedPlayer,
                currentPlayer: currentPlayer,
                tradeAmount: $tradeAmount,
                propertiesToEndWithSecondPlayer: $propertiesToEndWithSecondPlayer,
                propertiesToEndWithOriginalPlayer: $propertiesToEndWithOriginalPlayer
            )
        } else {
            
            ScrollView {
                
                VStack (spacing: 0) {
                    // Display the selected properties
                    Group {
                        Text("Properties to Trade Away:")
                        
                        
                        ScrollView(.horizontal) {
                            if propertiesToEndWithSecondPlayer.isEmpty {
                                Text("No properties selected").padding(.vertical)
                                
                            } else {
                                
                                HStack(spacing: 10) {
                                    ForEach(propertiesToEndWithSecondPlayer) { property in
                                        Text(property.name)
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                    
                    Group {
                        Text("Properties to Receive:")
                        ScrollView(.horizontal) {
                            if propertiesToEndWithOriginalPlayer.isEmpty {
                                Text("No properties selected") .padding(.vertical)
                            } else {
                                
                                HStack(spacing: 10) {
                                    ForEach(propertiesToEndWithOriginalPlayer) { property in
                                        Text(property.name)
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                    
                    
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
                    
                    Text("Make a Trade")
                        .font(.title)
                        .padding()
                    
                    // Add Toggle buttons for each player that isn't the current player
                    let otherPlayers = playersData.players.filter { $0.id != currentPlayer.id }
                    if otherPlayers.count > 2 {
                        HStack {
                            ForEach(otherPlayers, id: \.self) { player in
                                Button(action: {
                                    selectedPlayer = player
                                }){
                                    Text("\(player.name)")
                                }
                                .padding()
                                .background(selectedPlayer == player ? Color.blue : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                            
                        }
                    }
                    else {Text("").onAppear{
                        selectedPlayer = otherPlayers.first
                    }
                    }
                    
                    Text("Select Properties to Trade Away:")
                    ScrollView(.horizontal) {
                        HStack(spacing: 10) {
                            
                            ForEach(propertiesData.properties, id: \.id) { property in
                                if property.owner == currentPlayer {
                                    TradePropertyCard(
                                        property: property,
                                        currentPlayer: currentPlayer,
                                        isSelected: isSelected(property: property, in: propertiesToEndWithSecondPlayer),
                                        toggleSelection: { toggleSelection(for: property, in: &propertiesToEndWithSecondPlayer) }
                                    )
                                }
                            }
                        }
                        
                        .padding()
                    }
                    
                    Text("Select Properties to Receive:")
                    ScrollView(.horizontal) {
                        HStack(spacing: 10) {
                            ForEach(propertiesData.properties, id: \.id) { property in
                                if property.owner != nil && property.owner == selectedPlayer {
                                    TradePropertyCard(
                                        property: property,
                                        currentPlayer: currentPlayer,
                                        isSelected: isSelected(property: property, in: propertiesToEndWithOriginalPlayer),
                                        toggleSelection: { toggleSelection(for: property, in: &propertiesToEndWithOriginalPlayer) }
                                    )
                                }
                            }
                        }
                        .padding()
                    }
                    .onChange(of: selectedPlayer) { selected in
                        print("selected", selected)
                        // Reset the properties list when the selected player changes
                        propertiesToEndWithOriginalPlayer = []
                    }
                    
                    Group{
                        // Offer Trade Button
                        // Trade Amount Input
                        Text("Enter Trade Amount:")
                        // Add input boxes for trade amount
                        
                        
                        Button("Offer Trade") {
                            isShowingConfirmationView = true
                        }
                        .padding()
                        
                        // Cancel Button
                        Button("Cancel") {
                            print("TEMP")
                        }
                        .padding()
                    }
                }
            }.background(.white)
        }
    }
}

struct TradeConfirmationView: View {
    var selectedPlayer: Player?
    var currentPlayer: Player
    @Binding var tradeAmount: Int
    @Binding var propertiesToEndWithSecondPlayer: [Property]
    @Binding var propertiesToEndWithOriginalPlayer: [Property]
    
    var body: some View {
        VStack {
            Text("Trade Confirmation")
                .font(.title)
                .padding()
            
            // Display selected trade details
            
            // Accept Trade Button
            Button("Accept") {
                // Implement logic for accepting the trade
            }
            .padding()
            
            // Offer Amendment Button
            Button("Offer Amendment") {
                // Implement logic for offering an amendment to the trade
            }
            .padding()
            
            // Reject Trade Button
            Button("Reject") {
                // Implement logic for rejecting the trade
            }
            .padding()
        }
    }
}
