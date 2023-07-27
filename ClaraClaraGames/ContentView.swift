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


            // The padding on this scrollview also impacts the padding of the gameboard due to parent sizing and use of UIScreen
                
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
                    }.padding(.horizontal)
                }
                .frame(minWidth: UIScreen.main.bounds.width, alignment: .leading)
                .padding()
                .position(x:  UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 0.65)
                
   
            VStack {
                Spacer(minLength: 30)
                if isShowingModal {
                    switch modalType {
                    case .setupGame:
                        SetupGameModalView(
                            isShowingModal: $isShowingModal,
                            playersCount: $playersCount,
                            gameBoard: $gameBoard, currentPlayerIndex: $players.currentPlayerIndex,
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
           
            
        Rectangle()
            .fill(Color.clear)
            .overlay(
                Rectangle()
                    .fill(Color.black.opacity(0.5))
            )
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
                self.tappedGroup = nil
            }

            if let group = tappedGroup as? String {

                VStack{
                    Spacer()
                    ScrollView{
                        VStack(spacing: 30) {
                            ForEach(groupedProperties[group]!.indices, id: \.self) { index in
                                let property = groupedProperties[group]![index]
                                DetailedPropertyCardView(property: property)
                                    .animation(.easeInOut)
                                
                            }
                        }
                    }
                    .padding()
                    .cornerRadius(10)
                    .shadow(radius: 3)
                    .onTapGesture {
                        self.tappedGroup = nil
                    }
                    Spacer()

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

