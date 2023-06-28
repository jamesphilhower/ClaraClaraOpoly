import SwiftUI

indirect enum ModalType {
    case setupGame
    case playerTurn
    case none
}

struct GameView: View {
    @EnvironmentObject var players: PlayersData
    @EnvironmentObject var propertiesData: PropertiesData
    
    @State private var modalType: ModalType = .none
    @State private var isShowingModal: Bool = false
    @State private var userStateVariable: Bool = false
    
    @State private var playersCount: Int = 0
    @State private var gameBoard: String = "Traditional"
    @State private var playerNames: [String] = ["James", "Clara", "Bart", "Earl"]
    
    @State private var diceRoll: Int = 0
    @State private var consecutiveDoubles: Int = 0
    @State private var inJail: Bool = false
    
    @State private var tappedGroup: String?
    
    func gameInProgress() -> Bool {
        if playersCount == 0 {
            return false
        }
        return true
    }
    
    func setupNewGame() {
        playersCount = 4
        isShowingModal = true
        modalType = .setupGame
    }
    
    
    var body: some View {
        ZStack {
            WoodGrainBackground(maxRotation: 2.0, maxRandomness: 10)
                .edgesIgnoringSafeArea(.all)
            
            GameBoardView(selectedGameBoard: gameBoard)
                .edgesIgnoringSafeArea(.horizontal)

            
            VStack {
                Spacer(minLength: 10)
                
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        ForEach(propertiesData.properties.reduce(into: [:]) { result, property in
                            result[property.group, default: []].append(property)
                        }.sorted(by: { $0.key < $1.key }), id: \.key) { group, groupProperties in
                            let playerOwnedProperties = groupProperties.filter { property in
                                property.owner == players.players[safe: players.currentPlayerIndex]
                            }
                            
                            ZStack {
                                ForEach(playerOwnedProperties.indices, id: \.self) { index in
                                    let property = playerOwnedProperties[index]
                                    PropertyCardView(property: property)
                                        .offset(x: CGFloat(index * 4), y: CGFloat(index * 4))
                                        
                                }
                            }
                            .onTapGesture {
                                tappedGroup = group
                            }
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: CGFloat(playerOwnedProperties.count * 4), trailing: CGFloat(playerOwnedProperties.count * 4)))
                        }
                    }
                }
//                .frame(minWidth: UIScreen.main.bounds.width, alignment: .leading)

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
            }.frame(maxHeight: .infinity)
            
                      
            
            if tappedGroup != nil {
                    let playerOwnedProperties = propertiesData.properties.filter { property in
                        property.owner == players.players[safe: players.currentPlayerIndex]
                        &&
                        property.group == tappedGroup

                    }
                    
                    GroupAlignmentView(tappedGroup: $tappedGroup, playerOwnedProperties: playerOwnedProperties)
                }
        }
        .onAppear {
            print("GameView appeared")
            // TODO Load the game data when the view appears
            loadGameData()
            
            if gameInProgress() {
                // Todo Implement your logic to handle resuming the game
                print("Game in progress")
            } else {
                print("No game in progress, proceed to setup")
                setupNewGame()
            }
        }
    }
}

struct GroupAlignmentView: View {
    @Binding var tappedGroup: String?
    let playerOwnedProperties: [Property]
    
    var groupedProperties: [String: [Property]] {
        var result: [String: [Property]] = [:]
        for property in playerOwnedProperties {
            result[property.group, default: []].append(property)
        }
        return result
    }
    
    var body: some View {
        ZStack {
            ForEach(groupedProperties.keys.sorted(), id: \.self) { group in
                VStack(spacing: 8) {
                    ForEach(groupedProperties[group]!.indices, id: \.self) { index in
                        let property = groupedProperties[group]![index]
                        PropertyCardView(property: property)
                            .scaleEffect(tappedGroup == group ? 1.1 : 1)
                            .animation(.easeInOut)
                            .onTapGesture {
                                tappedGroup = property.group
                            }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 3)
                .opacity(tappedGroup == group ? 1 : 0)
                .zIndex(tappedGroup == group ? 1 : 0)
            }
            
            if let tappedGroup = tappedGroup {
                Rectangle()
                    .fill(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.black.opacity(0.5))
                    )
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        self.tappedGroup = nil
                    }
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        GameView()
    }
}

