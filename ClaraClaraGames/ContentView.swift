import SwiftUI

struct GameView: View {
    @State private var isShowingModal: Bool = false
    @State private var userStateVariable: Bool = false
    
    @State private var playersCount: Int = 2
    @State private var gameBoard: String = "Traditional"
    @State private var playerNames: [String] = ["", "", "", ""]
    @State private var currentPlayerIndex: Int = 0
    @EnvironmentObject var players: PlayersData
    @State private var diceRoll: Int = 0
    @State private var consecutiveDoubles: Int = 0
    @State private var inJail: Bool = false
    
    @State private var isShowingSetupModal: Bool = true
    @State private var isShowingPlayerTurnModal: Bool = false
    @State private var isShowingTradeModal: Bool = false
    
    // Dice rolling animation
    @EnvironmentObject private var diceAnimationData: DiceAnimationData

    
    // Check if a game is already in progress
    func gameInProgress() -> Bool {
        if playersCount == 0 {
            return false
        }
        return true
    }
    
    // Set up a new game
    func setupNewGame() {
        playersCount = 2
        isShowingModal = true
        isShowingSetupModal = true
    }
    
    var body: some View {
        VStack {
            Text("Header Placeholder")
                .font(.title)
                .padding()
            
            
            ZStack {
                
                VStack {
                    GameBoardView(selectedGameBoard: gameBoard)
                    
                    Button(action: {
                        isShowingModal = true
                    }) {
                        if isShowingSetupModal {
                            Text("Open Setup Game Modal")
                        } else if isShowingPlayerTurnModal {
                            Text("Open Player Turn Modal")
                        } else if isShowingTradeModal {
                            Text("Open Trade Modal")
                        }
                    }
                }
                    
                if isShowingSetupModal {
                    SetupGameModalView(
                        isShowingModal: $isShowingSetupModal,
                        playersCount: $playersCount,
                        gameBoard: $gameBoard,
                        playerNames: $playerNames,
                        currentPlayerIndex: $currentPlayerIndex
                    )
                } else if isShowingPlayerTurnModal {
                    PlayerTurnModalView(
                        isShowingModal: $isShowingPlayerTurnModal,
                        currentPlayerIndex: currentPlayerIndex
                    )
                } else if isShowingTradeModal {
                    TradeModalView(
                        isShowingModal: $isShowingTradeModal,
                        currentPlayerIndex: currentPlayerIndex
                    )
                }
                
                if diceAnimationData.isFlashing { // Display the dice view with cycling numbers during flashing animation
                    DiceView()
                        .frame(width: 100, height: 100)
                        .background(.green)
                        .padding()
                }
                
            }
            
        }
        .onAppear {
            // Load the game data when the view appears
            loadGameData()
            
            if gameInProgress() {
                // Game is already in progress, so resume the game
                // Implement your logic to handle resuming the game
            } else {
                // No game in progress, so set up a new game
                //setupNewGame()
            }
        }
    }
}


struct ContentView: View {
    var body: some View {
        GameView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
