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

        let propertyInit = [
            // 0
            Start(),
            BuildableProperty(name: "Scooter Shop", group: "brown", iconName: "scooter",mortgageValue: 100, unMortgageCost: 110, baseRent: 2,  housingRates: [10, 30, 90, 160, 250], hotelRate: 300, housePrice: 50, hotelPrice: 200, sellHouseFor: 25, sellHotelFor: 100),
            CommunityChest(),
            BuildableProperty(name: "Bike Shop", group: "brown", iconName: "bicycle",mortgageValue: 100, unMortgageCost: 110, baseRent: 4,  housingRates: [20, 60, 180, 320, 450], hotelRate: 450, housePrice: 50, hotelPrice: 200, sellHouseFor: 25, sellHotelFor: 100),
            IncomeTax(),
            Railroad(name: "R1", group: "rr", iconName: "train.side.front.car"),
            BuildableProperty(name: "Subway Station", group: "lightBlue", iconName: "tram.fill.tunnel", mortgageValue: 60, unMortgageCost: 66, baseRent: 6,  housingRates: [2, 10, 30, 90, 160], hotelRate: 250, housePrice: 50, hotelPrice: 50, sellHouseFor: 25, sellHotelFor: 25),
            Chance(),
            BuildableProperty(name: "Bus Station", group: "lightBlue", iconName: "bus", mortgageValue: 60, unMortgageCost: 66, baseRent: 6,  housingRates: [2, 10, 30, 90, 160], hotelRate: 250, housePrice: 50, hotelPrice: 50, sellHouseFor: 25, sellHotelFor: 25),
            BuildableProperty(name: "Train Station", group: "lightBlue", iconName: "cablecar", mortgageValue: 100, unMortgageCost: 110, baseRent: 10,  housingRates: [6, 30, 90, 270, 400], hotelRate: 550, housePrice: 50, hotelPrice: 50, sellHouseFor: 25, sellHotelFor: 25),
            Jail(),
            BuildableProperty(name: "Hat & Tassle", group: "pink", iconName: "graduationcap", mortgageValue: 100, unMortgageCost: 110, baseRent: 10,  housingRates: [6, 30, 90, 270, 400], hotelRate: 550, housePrice: 50, hotelPrice: 50, sellHouseFor: 25, sellHotelFor: 25),
            Utility(name: "The Outlets", group: "utilities", iconName: "poweroutlet.type.b"),
            BuildableProperty(name: "Backpack", group: "pink", iconName: "backpack" , mortgageValue: 100, unMortgageCost: 110, baseRent: 10,  housingRates: [6, 30, 90, 270, 400], hotelRate: 550, housePrice: 50, hotelPrice: 50, sellHouseFor: 25, sellHotelFor: 25),
            BuildableProperty(name: "Book Store", group: "pink", iconName: "text.book.closed", mortgageValue: 120, unMortgageCost: 132, baseRent: 12,  housingRates: [8, 40, 100, 300, 450], hotelRate: 600, housePrice: 50, hotelPrice: 50, sellHouseFor: 25, sellHotelFor: 25),
            Railroad(name: "R2", group: "rr", iconName: "train.side.middle.car"),
            BuildableProperty(name: "Departures", group: "orange", iconName: "departure", mortgageValue: 140, unMortgageCost: 154, baseRent: 14,  housingRates: [10, 50, 150, 450, 625], hotelRate: 750, housePrice: 100, hotelPrice: 100, sellHouseFor: 50, sellHotelFor: 50),
            CommunityChest(),
            BuildableProperty(name: "Airplane", group: "orange", iconName: "airplane", mortgageValue: 140, unMortgageCost: 154, baseRent: 14,  housingRates: [10, 50, 150, 450, 625], hotelRate: 750, housePrice: 100, hotelPrice: 100, sellHouseFor: 50, sellHotelFor: 50),
            BuildableProperty(name: "Arrivals", group: "orange", iconName: "arrival", mortgageValue: 160, unMortgageCost: 176, baseRent: 16,  housingRates: [12, 60, 180, 500, 700], hotelRate: 900, housePrice: 100, hotelPrice: 100, sellHouseFor: 50, sellHotelFor: 50),
            FreeParking(),
            BuildableProperty(name: "Gossip Media", group: "red", iconName: "magazine", mortgageValue: 220, unMortgageCost: 242, baseRent: 18,  housingRates: [14, 70, 200, 550, 750], hotelRate: 950, housePrice: 150, hotelPrice: 150, sellHouseFor: 75, sellHotelFor: 75),
            Chance(),
            BuildableProperty(name: "News Media", group: "red", iconName: "newspaper", mortgageValue: 220, unMortgageCost: 242, baseRent: 18,  housingRates: [14, 70, 200, 550, 750], hotelRate: 950, housePrice: 150, hotelPrice: 150, sellHouseFor: 75, sellHotelFor: 75),
            BuildableProperty(name: "Talk Radio", group: "red", iconName: "radio", mortgageValue: 240, unMortgageCost: 264, baseRent: 20,  housingRates: [16, 80, 220, 600, 800], hotelRate: 1000, housePrice: 150, hotelPrice: 150, sellHouseFor: 75, sellHotelFor: 75),
            Railroad(name: "R3", group: "rr", iconName: "train.side.middle.car"),
            BuildableProperty(name: "Cell Towers", group: "yellow", iconName: "cellularbars ", mortgageValue: 160, unMortgageCost: 180, baseRent: 22,  housingRates: [14, 50, 150, 450, 625], hotelRate: 750, housePrice: 100, hotelPrice: 200, sellHouseFor: 50, sellHotelFor: 100),
            Utility(name: "The Plug", group: "utilities", iconName: "powerplug"),
            BuildableProperty(name: "Wifi", group: "yellow", iconName: "wifi", mortgageValue: 160, unMortgageCost: 180, baseRent: 22,  housingRates: [14, 50, 150, 450, 625], hotelRate: 750, housePrice: 100, hotelPrice: 200, sellHouseFor: 50, sellHotelFor: 100),
            BuildableProperty(name: "The Cloud", group: "yellow", iconName: "cloud", mortgageValue: 160, unMortgageCost: 180, baseRent: 24,  housingRates: [16, 60, 180, 500, 700], hotelRate: 900, housePrice: 100, hotelPrice: 200, sellHouseFor: 50, sellHotelFor: 100),
            GoToJail(),
            BuildableProperty(name: "Vaccines", group: "green", iconName: "syringe", mortgageValue: 200, unMortgageCost: 220, baseRent: 26,  housingRates: [18, 90, 250, 700, 875], hotelRate: 1050, housePrice: 150, hotelPrice: 200, sellHouseFor: 75, sellHotelFor: 100),
            BuildableProperty(name: "Allergies", group: "green", iconName: "allergens", mortgageValue: 200, unMortgageCost: 220, baseRent: 26,  housingRates: [18, 90, 250, 700, 875], hotelRate: 1050, housePrice: 150, hotelPrice: 200, sellHouseFor: 75, sellHotelFor: 100),
            CommunityChest(),
            BuildableProperty(name: "Covid Shield", group: "green", iconName: "facemask", mortgageValue: 200, unMortgageCost: 220, baseRent: 28,  housingRates: [20, 100, 300, 750, 925], hotelRate: 1100, housePrice: 150, hotelPrice: 200, sellHouseFor: 75, sellHotelFor: 100),
            Railroad(name: "R4", group: "rr", iconName: "train.side.rear.car"),
            Chance(),
            BuildableProperty(name: "The Blue House", group: "darkBlue", iconName: "crown", mortgageValue: 350, unMortgageCost: 400, baseRent: 35,  housingRates: [35, 175, 500, 1100, 1300], hotelRate: 1500, housePrice: 200, hotelPrice: 200, sellHouseFor: 100, sellHotelFor: 100),
            LuxuryTax(),
            BuildableProperty(name: "Congress", group: "darkBlue", iconName: "building.columns", mortgageValue: 100, unMortgageCost: 110, baseRent: 16,  housingRates: [40, 80, 220, 600, 800], hotelRate: 1000, housePrice: 50, hotelPrice: 200, sellHouseFor: 25, sellHotelFor: 100)
        ]

        let propertiesWithoutSiblings = propertyInit

        // Add the created properties to your propertiesData object

        propertiesData.properties = assignSiblings(to: propertiesWithoutSiblings)
    }
    var body: some View {
        
        VStack {
            ZStack {
                WoodGrainBackground(numberOfPanels: 20, maxRotation: 2.0, maxRandomness: 10)
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

                    
                    BillsView(bills: calculateBills(for: 1287))
                    
                    Spacer(minLength: 50)
                    
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
                    
                }
                            
                
            }.frame(height: .infinity)
            
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

