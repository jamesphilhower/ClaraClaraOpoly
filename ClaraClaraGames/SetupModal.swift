import SwiftUI


struct SetupGameModalView: View {
    @Binding var isShowingModal: Bool
    @Binding var playersCount: Int
    @Binding var gameBoard: String
    @Binding var currentPlayerIndex: Int
    @Binding var modalType: ModalType
    @State private var playerNames: [String] = ["James", "Clara", "Bart", "Earl"]
    @State private var playerIcons: [String] = ["figure.run", "figure.climbing", "figure.run", "figure.run"]

    @EnvironmentObject var playersData: PlayersData
    @EnvironmentObject var propertiesData: PropertiesData
    @EnvironmentObject var cards: CardsData

    @State private var isAISelectionEnabled: [Bool] = [false, false, false, false]
    
    @State private var selectedGameBoard: String = "Traditional"
    @EnvironmentObject private var diceAnimation: DiceAnimationData
    
    func createPlayers() -> [Player] {
        var players = [Player]()
        for index in 0..<playersCount {
            let playerName = playerNames[index]
            let isAI = isAISelectionEnabled[index]
            let player = Player(playersData: playersData, cards: cards, propertiesData: propertiesData, id: index, name: playerName, isAI: isAI, iconName: playerIcons[index])
            players.append(player)
        }
        return players
    }
    
    func decideWhoGoesFirst(players: [Player]) async -> Int {
        var highestRoll = 0
        var firstPlayerIndex = 0
        print("before the for loop")

        for index in 0..<players.count {
            print("inside \(index)")
            let roll = await diceAnimation.startDiceAnimationWrapper(isTwoDice: false)[0]
            print("Result for player \(index): \(roll)")

            if roll > highestRoll {
                highestRoll = roll
                firstPlayerIndex = index
            }
            
            do {
                print("do")
                try await Task.sleep(nanoseconds: 500_000_000) // Wait for 0.5 seconds before the next player rolls
            } catch {
                // Handle the error or simply continue execution
                print("Error: \(error)")
                continue
            }
        }
        
        return firstPlayerIndex
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Setup New Game")
                    .font(.title)
                    .padding()
                
                // Number of players selection
                Stepper(value: $playersCount, in: 2...4) {
                    Text("Number of Players: \(playersCount)")
                }
                .padding()
                
                // Game board selection
                Picker(selection: $selectedGameBoard, label: Text("Game Board")) {
                    Text("Traditional").tag("Traditional")
                    Text("Infinity").tag("Infinity")
                    Text("Shoots and Ladders").tag("ShootsAndLadders")
                }
                .pickerStyle(.wheel) // Use wheel style for vertical picker
                .frame(width: 250) // Adjust the width to fit the content
                
                // Player name and AI toggle
                ForEach(0..<playersCount, id: \.self) { index in
                    VStack {
                        TextField("Player \(index+1)", text: $playerNames[index])
                            .padding()
                        
                        if index > 0 {
                            Toggle("AI", isOn: $isAISelectionEnabled[index])
                                .padding(.horizontal)
                        }
                    }
                }
            }
         
            
            Button(action:  {
                // Create player objects and assign them to the players bound variable
                playersData.players = createPlayers()
                gameBoard = selectedGameBoard
                Task {
//                    print("button before task")
//                    let firstPlayerIndex = await decideWhoGoesFirst(players: playersData.players)
                    currentPlayerIndex = 0

                    //currentPlayerIndex = firstPlayerIndex

//                    isShowingModal = false
                    isShowingModal = true
                    let numPlayers = playersData.players.count
                    print("players", numPlayers)
                    for property in propertiesData.properties {
                        let playerIndex = Int.random(in: 0..<numPlayers)
                        let player = playersData.players[playerIndex]
                        property.owner = player
                        property.isMortgaged = Bool.random() && Bool.random() && Bool.random()
                        if !property.isMortgaged {
                            if let buildableProperty = property as? BuildableProperty {
                                let count = Int.random(in: 0...4)
                                if count <= 4 {
                                    buildableProperty.numberHouses = count
                                } else {
                                    buildableProperty.numberHouses = 4
                                    buildableProperty.hasHotel = true
                                }
                            }
                        }
                    }
                    modalType = .playerTurn
                }

            }) {
                Text("Start Game")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }.onAppear{
                if isDevelopment {
                    playersData.players = createPlayers()
                    gameBoard = selectedGameBoard
                    Task {
                        //                    print("button before task")
                        //                    let firstPlayerIndex = await decideWhoGoesFirst(players: playersData.players)
                        currentPlayerIndex = 0
                        
                        //currentPlayerIndex = firstPlayerIndex
                        
                        //                    isShowingModal = false
                        isShowingModal = true
                        let numPlayers = playersData.players.count
                        print("players", numPlayers)
                        for property in propertiesData.properties {
                            let playerIndex = Int.random(in: 0..<numPlayers)
                            let player = playersData.players[playerIndex]
                            property.owner = player
                            property.isMortgaged = Bool.random() && Bool.random() && Bool.random()
                            if !property.isMortgaged {
                                if let buildableProperty = property as? BuildableProperty {
                                    let count = Int.random(in: 0...4)
                                    if count <= 4 {
                                        buildableProperty.numberHouses = count
                                    } else {
                                        buildableProperty.numberHouses = 4
                                        buildableProperty.hasHotel = true
                                    }
                                }
                            }
                        }
                        modalType = .playerTurn
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding()
    }
}
