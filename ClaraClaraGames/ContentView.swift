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
    @State private var currentPlayerIndex: Int = 0
    @EnvironmentObject var players: PlayersData
    @EnvironmentObject var propertiesData: PropertiesData
    
    @State private var diceRoll: Int = 0
    @State private var consecutiveDoubles: Int = 0
    @State private var inJail: Bool = false
    
    @State private var modalType: ModalType = .none
    
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
        modalType = .setupGame
        // Create railroads
        
        let railRoads = [
            Railroad(name: "R1", icon: Icons.trainFront),
            Railroad(name: "R2", icon: Icons.trainMid),
            Railroad(name: "R3", icon: Icons.trainMid),
            Railroad(name: "R4", icon: Icons.trainEnd)
        ]
        
        // Create utilities
        let utilities = [
            Utility(name: "U1", icon: Icons.plug),
            Utility(name: "U2", icon: Icons.plug)]
        
        
        let browns = [
            BuildableProperty(name: "Mediterranean Avenue", icon: Icons.scooter      ,mortgageValue: 100, unMortgageCost: 110, baseRent: 2, siblings: [], numberHouses: 0, hasHotel: false, housingRates: [10, 30, 90, 160, 250], hotelRate: 300, housePrice: 50, hotelPrice: 200, sellHouseFor: 25, sellHotelFor: 100),
            BuildableProperty(name: "Baltic Avenue", icon: Icons.bicycle      ,mortgageValue: 100, unMortgageCost: 110, baseRent: 4, siblings: [], numberHouses: 0, hasHotel: false, housingRates: [20, 60, 180, 320, 450], hotelRate: 450, housePrice: 50, hotelPrice: 200, sellHouseFor: 25, sellHotelFor: 100)
        ]

        let lightBlues = [
            BuildableProperty(name: "Connecticut Avenue", icon: Icons.subway      , mortgageValue: 60, unMortgageCost: 66, baseRent: 6, siblings: [], numberHouses: 0, hasHotel: false, housingRates: [2, 10, 30, 90, 160], hotelRate: 250, housePrice: 50, hotelPrice: 50, sellHouseFor: 25, sellHotelFor: 25),
            BuildableProperty(name: "Vermont Avenue", icon: Icons.bus      , mortgageValue: 60, unMortgageCost: 66, baseRent: 6, siblings: [], numberHouses: 0, hasHotel: false, housingRates: [2, 10, 30, 90, 160], hotelRate: 250, housePrice: 50, hotelPrice: 50, sellHouseFor: 25, sellHotelFor: 25),
            BuildableProperty(name: "Oriental Avenue", icon: Icons.cablecar      , mortgageValue: 100, unMortgageCost: 110, baseRent: 10, siblings: [], numberHouses: 0, hasHotel: false, housingRates: [6, 30, 90, 270, 400], hotelRate: 550, housePrice: 50, hotelPrice: 50, sellHouseFor: 25, sellHotelFor: 25)
        ]
        
        let pinks = [
            BuildableProperty(name: "St. Charles Place", icon: Icons.graduationCap      , mortgageValue: 100, unMortgageCost: 110, baseRent: 10, siblings: [], numberHouses: 0, hasHotel: false, housingRates: [6, 30, 90, 270, 400], hotelRate: 550, housePrice: 50, hotelPrice: 50, sellHouseFor: 25, sellHotelFor: 25),
            BuildableProperty(name: "States Avenue", icon: Icons.backpack     , mortgageValue: 100, unMortgageCost: 110, baseRent: 10, siblings: [], numberHouses: 0, hasHotel: false, housingRates: [6, 30, 90, 270, 400], hotelRate: 550, housePrice: 50, hotelPrice: 50, sellHouseFor: 25, sellHotelFor: 25),
            BuildableProperty(name: "Virginia Avenue", icon: Icons.textBookClosed   , mortgageValue: 120, unMortgageCost: 132, baseRent: 12, siblings: [], numberHouses: 0, hasHotel: false, housingRates: [8, 40, 100, 300, 450], hotelRate: 600, housePrice: 50, hotelPrice: 50, sellHouseFor: 25, sellHotelFor: 25)
        ]
        
        let oranges = [
            BuildableProperty(name: "St. James Place", icon: Icons.departure    , mortgageValue: 140, unMortgageCost: 154, baseRent: 14, siblings: [], numberHouses: 0, hasHotel: false, housingRates: [10, 50, 150, 450, 625], hotelRate: 750, housePrice: 100, hotelPrice: 100, sellHouseFor: 50, sellHotelFor: 50),
            BuildableProperty(name: "Tennessee Avenue", icon: Icons.airplane   , mortgageValue: 140, unMortgageCost: 154, baseRent: 14, siblings: [], numberHouses: 0, hasHotel: false, housingRates: [10, 50, 150, 450, 625], hotelRate: 750, housePrice: 100, hotelPrice: 100, sellHouseFor: 50, sellHotelFor: 50),
            BuildableProperty(name: "New York Avenue", icon: Icons.arrival   , mortgageValue: 160, unMortgageCost: 176, baseRent: 16, siblings: [], numberHouses: 0, hasHotel: false, housingRates: [12, 60, 180, 500, 700], hotelRate: 900, housePrice: 100, hotelPrice: 100, sellHouseFor: 50, sellHotelFor: 50)
        ]
        
        let reds = [
            BuildableProperty(name: "Kentucky Avenue", icon: Icons.magazine      , mortgageValue: 220, unMortgageCost: 242, baseRent: 18, siblings: [], numberHouses: 0, hasHotel: false, housingRates: [14, 70, 200, 550, 750], hotelRate: 950, housePrice: 150, hotelPrice: 150, sellHouseFor: 75, sellHotelFor: 75),
            BuildableProperty(name: "Indiana Avenue", icon: Icons.newspaper      , mortgageValue: 220, unMortgageCost: 242, baseRent: 18, siblings: [], numberHouses: 0, hasHotel: false, housingRates: [14, 70, 200, 550, 750], hotelRate: 950, housePrice: 150, hotelPrice: 150, sellHouseFor: 75, sellHotelFor: 75),
            BuildableProperty(name: "Illinois Avenue", icon: Icons.radio      , mortgageValue: 240, unMortgageCost: 264, baseRent: 20, siblings: [], numberHouses: 0, hasHotel: false, housingRates: [16, 80, 220, 600, 800], hotelRate: 1000, housePrice: 150, hotelPrice: 150, sellHouseFor: 75, sellHotelFor: 75)
        ]
        
        let yellows = [
            BuildableProperty(name: "Atlantic Avenue", icon: Icons.cellularbars       , mortgageValue: 160, unMortgageCost: 180, baseRent: 22, siblings: [], numberHouses: 0, hasHotel: false, housingRates: [14, 50, 150, 450, 625], hotelRate: 750, housePrice: 100, hotelPrice: 200, sellHouseFor: 50, sellHotelFor: 100),
            BuildableProperty(name: "Ventnor Avenue", icon: Icons.wifi      , mortgageValue: 160, unMortgageCost: 180, baseRent: 22, siblings: [], numberHouses: 0, hasHotel: false, housingRates: [14, 50, 150, 450, 625], hotelRate: 750, housePrice: 100, hotelPrice: 200, sellHouseFor: 50, sellHotelFor: 100),
            BuildableProperty(name: "Marvin Gardens", icon: Icons.cloud    , mortgageValue: 160, unMortgageCost: 180, baseRent: 24, siblings: [], numberHouses: 0, hasHotel: false, housingRates: [16, 60, 180, 500, 700], hotelRate: 900, housePrice: 100, hotelPrice: 200, sellHouseFor: 50, sellHotelFor: 100)
        ]
        
        let greens = [
            BuildableProperty(name: "Pacific Avenue", icon: Icons.syringe      , mortgageValue: 200, unMortgageCost: 220, baseRent: 26, siblings: [], numberHouses: 0, hasHotel: false, housingRates: [18, 90, 250, 700, 875], hotelRate: 1050, housePrice: 150, hotelPrice: 200, sellHouseFor: 75, sellHotelFor: 100),
            BuildableProperty(name: "North Carolina Avenue", icon: Icons.allergens      , mortgageValue: 200, unMortgageCost: 220, baseRent: 26, siblings: [], numberHouses: 0, hasHotel: false, housingRates: [18, 90, 250, 700, 875], hotelRate: 1050, housePrice: 150, hotelPrice: 200, sellHouseFor: 75, sellHotelFor: 100),
            BuildableProperty(name: "Pennsylvania Avenue", icon: Icons.faceMask      , mortgageValue: 200, unMortgageCost: 220, baseRent: 28, siblings: [], numberHouses: 0, hasHotel: false, housingRates: [20, 100, 300, 750, 925], hotelRate: 1100, housePrice: 150, hotelPrice: 200, sellHouseFor: 75, sellHotelFor: 100)
        ]
        let darkBlues = [
            BuildableProperty(name: "Park Place", icon: Icons.crown      , mortgageValue: 350, unMortgageCost: 400, baseRent: 35, siblings: [], numberHouses: 0, hasHotel: false, housingRates: [35, 175, 500, 1100, 1300], hotelRate: 1500, housePrice: 200, hotelPrice: 200, sellHouseFor: 100, sellHotelFor: 100),
            BuildableProperty(name: "Boardwalk", icon: Icons.congress      , mortgageValue: 100, unMortgageCost: 110, baseRent: 16, numberHouses: 0, hasHotel: false, housingRates: [40, 80, 220, 600, 800], hotelRate: 1000, housePrice: 50, hotelPrice: 200, sellHouseFor: 25, sellHotelFor: 100)
        ]
        
        
        let propertiesWithoutSiblings = [railRoads, utilities, browns, lightBlues, pinks, oranges, reds, yellows, greens, darkBlues] as [[Property]]
        
        // Add the created properties to your propertiesData object
        propertiesData.properties = assignSiblings(to: propertiesWithoutSiblings)
    }
    var body: some View {
        
        VStack {
            Text("Header Placeholder")
                .font(.title)
                .padding()
            
            
            ZStack {
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
                }
                if isShowingModal {
                    switch modalType {
                    case .setupGame:
                        SetupGameModalView(
                            isShowingModal: $isShowingModal,
                            playersCount: $playersCount,
                            gameBoard: $gameBoard,
                            playerNames: $playerNames,
                            currentPlayerIndex: $currentPlayerIndex,
                            modalType: $modalType
                        )
                        
                    case .playerTurn:
                        PlayerTurnModalView(
                            isShowingModal: $isShowingModal,
                            currentPlayerIndex: $currentPlayerIndex,
                            modalType: $modalType
                        )
                        
                    case .none:
                        EmptyView()
                    }
                }
                
                // todo change isFlashing
                if diceAnimationData.isFlashing { // Display the dice view with cycling numbers during flashing animation
                    DiceView()
                        .frame(width: 100, height: 100)
                        .background(.green)
                        .padding()
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
