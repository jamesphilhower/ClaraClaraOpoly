import SwiftUI

struct PropertiesInSetIconView: View {
    @EnvironmentObject var propertiesData: PropertiesData
    
    let ownedProperties: [String]
    let unownedProperties: [String]
    
    var body: some View {
        let combinedProperties = ownedProperties + unownedProperties
        let sortedProperties = combinedProperties.sorted()
        
        return HStack {
            ForEach(sortedProperties, id: \.self) { propertyName in
                let currentProperty = propertiesData.properties.first(where: { $0.name == propertyName }) as! BuildableProperty
                
                currentProperty.buildableIcon
                    .foregroundColor(ownedProperties.contains(currentProperty.name) ? .green : .gray)
                    .frame(width:  currentProperty.iconDimensions.1, height: currentProperty.iconDimensions.0)
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
}

enum CashOffer: Int, CaseIterable {
    case offerCash = -1
    case noCash = 0
    case requestCash = 1
    
    var description: String {
        switch self {
        case .offerCash:
            return "Offer Cash"
        case .noCash:
            return "No Cash"
        case .requestCash:
            return "Request Cash"
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
    
    @EnvironmentObject private var diceAnimation: DiceAnimationData
    @EnvironmentObject var propertiesData: PropertiesData
    @EnvironmentObject var playersData: PlayersData
    
    @State var cashAmount: Int = 0
    @State private var propertiesToEndWithOriginalPlayer: [Property] = []
    @State private var propertiesToEndWithSecondPlayer: [Property] = []
    @State private var isShowingConfirmationView = false
    @State var isAmendment = false
    @State var cashOffer: CashOffer = .noCash

    @Binding var currentPlayerAction: PlayerActionsType
    @Binding var currentPlayer: Player
    
    @State private var selectedPlayer: Player? {
        didSet {
            print("selectedPlayer didSet:", selectedPlayer?.name ?? "nil")
            propertiesToEndWithOriginalPlayer = propertiesData.properties.filter { property in
                property.owner != nil && property.owner == selectedPlayer
            }
            print("propertiesToEndWithOriginalPlayer:", propertiesToEndWithOriginalPlayer)
        }
    }
    
    var body: some View {
        
        
        if isShowingConfirmationView {
            TradeConfirmationView(
                selectedPlayer: $selectedPlayer,
                currentPlayer: $currentPlayer,
                cashAmount: cashAmount,
                propertiesToEndWithSecondPlayer: $propertiesToEndWithSecondPlayer,
                propertiesToEndWithOriginalPlayer: $propertiesToEndWithOriginalPlayer,
                isShowingConfirmationView: $isShowingConfirmationView,
                isAmendment: $isAmendment,
                cashOffer: cashOffer
                
            )
        } else {
            
            VStack {
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
                else {
                    Text("").onAppear{
                        selectedPlayer = otherPlayers.first
                    }
                }
                
                HStack {
                    Spacer()
                    Button(action: {
                        currentPlayerAction = .none
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                    .padding()
                }
                
                ScrollView(showsIndicators: false) {
                    VStack (spacing: 0) {
                        HStack {Text("Trading For:"); Spacer()}
                        ScrollView(.horizontal) {
                            HStack(spacing: 10) {
                                ForEach(propertiesData.properties, id: \.id) { property in
                                    if property.owner != nil && property.owner == selectedPlayer {
                                        TradePropertyCard(
                                            property: property,
                                            currentPlayer: currentPlayer,
                                            isSelected: isSelected(property: property, in: propertiesToEndWithOriginalPlayer),
                                            isPurchasing: true,
                                            toggleSelection: { toggleSelection(for: property, in: &propertiesToEndWithOriginalPlayer) }
                                        )
                                    }
                                }
                            }
                            .padding(EdgeInsets(top : 10, leading: 5, bottom: 10, trailing: 10))
                        }
                        .onChange(of: selectedPlayer) { selected in
                            // Reset the properties list when the selected player changes
                            propertiesToEndWithOriginalPlayer = []
                        }
                        HStack {Text("Trading Away:"); Spacer()}
                        ScrollView(.horizontal) {
                            HStack(spacing: 10) {
                                ForEach(propertiesData.properties, id: \.id) { property in
                                    if property.owner == currentPlayer {
                                        TradePropertyCard(
                                            property: property,
                                            currentPlayer: currentPlayer,
                                            isSelected: isSelected(property: property, in: propertiesToEndWithSecondPlayer),
                                            isPurchasing: false,
                                            toggleSelection: { toggleSelection(for: property, in: &propertiesToEndWithSecondPlayer) }
                                        )
                                    }
                                }
                            }
                            .padding(EdgeInsets(top : 10, leading: 5, bottom: 10, trailing: 10))
                        }
                        
                        Group{
                            Picker("Select Cash Direction", selection: $cashOffer) {
                                ForEach(CashOffer.allCases, id: \.self) { option in
                                    Text(option.description).tag(option)
                                }
                            }.pickerStyle(.segmented)
                            
                            TextField("Enter Cash", value: $cashAmount, formatter: NumberFormatter())
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                                .disabled(cashOffer == .noCash)
                                .frame(width: 150) // Adjust the width as needed
                                .onChange(of: cashOffer) { newCashOffer in
                                    if newCashOffer == .offerCash {
                                        cashAmount = max(0, min(cashAmount, currentPlayer.money))
                                    } else if newCashOffer == .requestCash {
                                        cashAmount = max(0, min(cashAmount, selectedPlayer?.money ?? 0))
                                    }
                                }
                            
                            
                            let bills = calculateBills(for: cashAmount)
                            let zeroBill = calculateBills(for: 0)
                            Group {
                                HStack(alignment: .center) {
                                    Image(systemName: "cart").frame(height: 50)
                                    ScrollView(.horizontal) {
                                        HStack {
                                            BillsView(bills: cashOffer == .requestCash ? bills : zeroBill)
                                            
                                            if propertiesToEndWithOriginalPlayer.isEmpty && (cashOffer != .requestCash || (cashOffer == .requestCash && cashAmount == 0 )){
                                                Text("No selections") .padding(.vertical)
                                            } else {
                                                
                                                HStack(spacing: 10) {
                                                    ForEach(propertiesToEndWithOriginalPlayer) { property in
                                                        Text(property.name)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }.frame(minHeight: 100)
                            }
                            
                            Group {
                                HStack(alignment: .center) {
                                    Image(systemName: "shippingbox.and.arrow.backward").frame(height: 50)
                                    ScrollView(.horizontal) {
                                        HStack {
                                            
                                            BillsView(bills: cashOffer == .offerCash ? bills : zeroBill)
                                            
                                            if propertiesToEndWithSecondPlayer.isEmpty && (cashOffer != .offerCash || (cashOffer == .offerCash && cashAmount == 0 )) {
                                                Text("No selections").padding(.vertical)
                                                
                                            } else {
                                                
                                                ForEach(propertiesToEndWithSecondPlayer) { property in
                                                    Text(property.name)
                                                }
                                            }
                                        }
                                    }
                                }.frame(minHeight: 100)
                            }
                            
                            HStack {
                                Image(systemName: "signature")
                                Button("Offer Trade") {
                                    isShowingConfirmationView = true
                                }
                                
                            }
                        }
                    }
                    
                }.background(.white)
            }
        }
    }
}

struct TradeConfirmationView: View {
    @Binding var selectedPlayer: Player?
    @Binding var currentPlayer: Player
    var cashAmount: Int
    @Binding var propertiesToEndWithSecondPlayer: [Property]
    @Binding var propertiesToEndWithOriginalPlayer: [Property]
    @Binding var isShowingConfirmationView: Bool
    @Binding var isAmendment: Bool
    var cashOffer: CashOffer
    @EnvironmentObject var propertiesData: PropertiesData
    
    func swapOwners() {
        // Swap owners of properties with the other player
        for property in propertiesToEndWithSecondPlayer {
            if let curProp = propertiesData.properties.first(where: { $0.id == property.id }) {
                print("Before swap: \(curProp.name), owner: \(curProp.owner?.name ?? "")")
                curProp.owner = selectedPlayer
                print("After swap: \(curProp.name), owner: \(curProp.owner?.name ?? "")")
            }
        }
        for property in propertiesToEndWithOriginalPlayer {
            if let curProp = propertiesData.properties.first(where: { $0.id == property.id }) {
                print("Before swap: \(curProp.name), owner: \(curProp.owner?.name ?? "")")
                curProp.owner = currentPlayer
                print("After swap: \(curProp.name), owner: \(curProp.owner?.name ?? "")")
            }
        }
        
        if cashOffer != .noCash {
            if let selectedPlayer = selectedPlayer {
                currentPlayer.money += cashAmount
                selectedPlayer.money -= cashAmount
                print("Current player money: \(currentPlayer.money)")
                print("Selected player money: \(selectedPlayer.money)")
            }
        }
    }

    
    var body: some View {
        VStack {
            Text("Trade Confirmation")
                .font(.title)
                .padding()
            
            // Accept Trade Button
            Button("Accept") {
                // Implement logic for accepting the trade
                swapOwners()
                isShowingConfirmationView = false
            }
            .padding()
            
            // Offer Amendment Button
            Button("Offer Amendment") {
                // Implement logic for offering an amendment to the trade
                isAmendment = !isAmendment
                isShowingConfirmationView = false
            }
            .padding()
            
            // Reject Trade Button
            Button("Reject") {
                // Implement logic for rejecting the trade
                isShowingConfirmationView = false
            }
            .padding()
        }.background(.white)
    }
}
