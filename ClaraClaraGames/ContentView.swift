import SwiftUI

// todo debug
// need to make it so everything is auto done until what we are working on with statements


indirect enum ModalType {
    case setupGame
    case playerTurn
    case none
}

struct GameView: View {
    @State private var isShowingModal: Bool = false
    @State private var userStateVariable: Bool = false
    
    @State private var playersCount: Int = 0
    @State private var gameBoard: String = "Traditional"
    @State private var playerNames: [String] = ["James", "Clara", "Bart", "Earl"]
    @EnvironmentObject var players: PlayersData
    @EnvironmentObject var propertiesData: PropertiesData
    
    @State private var diceRoll: Int = 0
    @State private var consecutiveDoubles: Int = 0
    @State private var inJail: Bool = false
    
    @State private var modalType: ModalType = .none
        
    // Check if a game is already in progress
    func gameInProgress() -> Bool {
        if playersCount == 0 {
            return false
        }
        return true
    }
    
    // Set up a new game
    func setupNewGame() {
        playersCount = 4
        isShowingModal = true
        modalType = .setupGame
    }
    var body: some View {
        
        VStack {
            ZStack {
                WoodGrainBackground(maxRotation: 2.0, maxRandomness: 10)
                           .edgesIgnoringSafeArea(.all)
                           
                VStack {
                    GameBoardView(selectedGameBoard: gameBoard)
                    
                    if !isShowingModal {
                        switch modalType {
                        case .setupGame:
                            Button(action: {
                                isShowingModal = true
                            }) {
                                Text("Open Setup Game Modal")
                            }
                            .buttonStyle(DefaultButtonStyle())
                            
                        case .playerTurn:
                            Button(action: {
                                isShowingModal = true
                            }) {
                                Text("Open Player Turn Modal")
                            }
                            .buttonStyle(DefaultButtonStyle())
                            
                        case .none:
                            Text("No modal to display")
                        }
                    }
                    Spacer(minLength: 10)

                    ZStack {
                        PlayerMoneyView(playersData: players)
                                                
                        if isShowingModal {
                            switch modalType {
                            case .setupGame:
                                SetupGameModalView(
                                    isShowingModal: $isShowingModal,
                                    playersCount: $playersCount,
                                    gameBoard: $gameBoard,
                                    playerNames: $playerNames,
                                    currentPlayerIndex: $players.currentPlayerIndex,
                                    modalType: $modalType
                                )
                                
                            case .playerTurn:
                                PlayerTurnModalView(
                                    isShowingModal: $isShowingModal,
                                    currentPlayerIndex: $players.currentPlayerIndex,
                                    modalType: $modalType
                                )
                                
                            case .none:
                                EmptyView()
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            print("appeared")
            // TODO Load the game data when the view appears
            loadGameData()
            
            if gameInProgress() {
                print("in")
                // Game is already in progress, so resume the game
                // Implement your logic to handle resuming the game
            } else {
                // No game in progress, so set up a new game
                print("setup")
                setupNewGame()
                
            }
        }
    }
}


struct PlayerMoneyView: View {
    @ObservedObject var playersData: PlayersData
    
    var body: some View {
        VStack {
            ForEach(playersData.players) { player in
                HStack {
                    Text(player.name)
                    Spacer()
                    Text("$\(player.money)")
                }
                .padding()
                .background(player.color.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)
            }
        }
    }
}



struct ContentView: View {
    var body: some View {
        GameView()
    }
}

