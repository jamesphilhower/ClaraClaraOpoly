import SwiftUI

struct PlayerTurnButton<Content: View>: View {
    let isEnabled: Bool
    let action: () -> Void
    let content: Content
    
    init(isEnabled: Bool, action: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.isEnabled = isEnabled
        self.action = action
        self.content = content()
    }
    
    var body: some View {
        Button(action: action) {
            content
        }
        .padding()
        .disabled(!isEnabled)
    }
}

enum PlayerActionsType {
    case trade
    case manageProperties
    case roll
    case payToGetOutOfJail
    case useGetOutOfJailFreeCard
    case endTurn
    case none
}


struct PlayerTurnModalView: View {
    @Binding var isShowingModal: Bool
    @Binding var currentPlayerIndex: Int
    @Binding var modalType: ModalType
    
    @State var  currentPlayerAction: PlayerActionsType = .none
    @State private var showTurnPopup = true
    @State var hasRolled: Bool = false
    @State var hideAll: Bool = false
    @State var doublesInARow: Int = 0
    
    @EnvironmentObject private var diceAnimation: DiceAnimationData
    @EnvironmentObject private var playersData: PlayersData
    
    func endTurnAndShowPopup() {
        
        // Move to the next player's turn
        currentPlayerIndex = (currentPlayerIndex + 1) % playersData.players.count
        
        // Show the turn popup
        showTurnPopup = true
        
        // Delay for a second and then hide the turn popup
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            showTurnPopup = false
        }
    }
    
    var body: some View {
        
        let currentPlayer = playersData.players[currentPlayerIndex]
        
        let buttons: [String: PlayerTurnButton<Text>] = [
            "Trade": PlayerTurnButton(
                isEnabled: true,
                action: {
                    currentPlayerAction = .trade
                },
                content: {
                    Text("Trade")
                }
            ),
            "ManageProperties": PlayerTurnButton(
                isEnabled: currentPlayer.ownsProperties,
                action: {
                    currentPlayerAction = .manageProperties
                },
                content: {
                    Text("Manage Properties")
                }
            ),
            "Roll": PlayerTurnButton(
                isEnabled: !hasRolled || currentPlayer.consecutiveTurnsInJail >= 3,
                action: {
                    // Implement roll action logic using the provided player instance
                    currentPlayerAction = .roll
//                    hasRolled = true
//                    if currentPlayer.inJail {
//                        playersData.players[currentPlayerIndex].consecutiveTurnsInJail += 1
//                        if currentPlayer.consecutiveTurnsInJail >= 3 {
//                            playersData.players[currentPlayerIndex].goToJail()
//                            endTurnAndShowPopup()
//                        }
//                    }
                    
                },
                content: {
                    Text("Roll")
                }
            ),
            "PayToGetOutOfJail": PlayerTurnButton(
                isEnabled: currentPlayer.inJail,
                action: {
                    currentPlayerAction = .payToGetOutOfJail
                    // Reset consecutive jail turns and isPlayerInJail flag
                    playersData.players[currentPlayerIndex].consecutiveTurnsInJail = 0
                    playersData.players[currentPlayerIndex].inJail = false
                    playersData.players[currentPlayerIndex].payToGetOutOfJail()
                },
                content: {
                    Text("Pay to Get Out of Jail")
                }
            ),
            "UseGetOutOfJailFreeCard": PlayerTurnButton(
                isEnabled: currentPlayer.inJail && currentPlayer.getOutOfJailCards > 0,
                action: {
                    currentPlayerAction = .useGetOutOfJailFreeCard
                    playersData.players[currentPlayerIndex].consecutiveTurnsInJail = 0
                    playersData.players[currentPlayerIndex].inJail = false
                    playersData.players[currentPlayerIndex].getOutOfJailCards -= 1
                },
                content: {
                    Text("Use Get Out of Jail Free Card")
                }
            ),
            "EndTurn": PlayerTurnButton(
                isEnabled: (currentPlayer.inJail && currentPlayer.consecutiveTurnsInJail < 3 && hasRolled) || (!currentPlayer.inJail && hasRolled),
                action: {
                    hasRolled = false
                    doublesInARow = 0
                    currentPlayerAction = .endTurn
                    endTurnAndShowPopup()
                },
                content: {
                    Text("End Turn")
                }
            )
        ]
        
        if !hideAll {
//            BaseModalView {
                ZStack {
                    VStack {
                        Text("Current Player: \(currentPlayer.name)")
                        
                        ForEach(buttons.filter { $0.value.isEnabled }, id: \.key) { key, button in
                            button
                        }
                    }.disabled(currentPlayerAction != .none)
                    
                    switch currentPlayerAction {
                    case .trade:
                        TradeModalView(currentPlayerAction: $currentPlayerAction, currentPlayer: $playersData.players[currentPlayerIndex])
                    case .manageProperties:
                        ManagePropertiesModal(currentPlayerAction: $currentPlayerAction, currentPlayer: currentPlayer)
                    case .roll:
                        VStack {
                            Rectangle().foregroundColor(.pink).frame(width: 0, height: 0)
                        }.onAppear {
                            Task {
                                hideAll = true

                                let rolls = await diceAnimation.startDiceAnimationWrapper(isTwoDice: true)
                                hasRolled = true
                                let r1 = rolls[0]
                                let r2 = rolls[1]
                                if r1 == r2 {
                                    print("DOUBLES")
                                    hasRolled = false
                                    doublesInARow += 1

                                    if doublesInARow >= 3 {
                                        playersData.players[currentPlayerIndex].goToJail()
                                    }
                                }
                                
                                for _ in (0..<(r1+r2)) {
                                    do {
                                        if currentPlayer.location == 40 {
                                            currentPlayer.location = 1
                                        } else {
                                            currentPlayer.location += 1
                                        }
                                        
//                                        try  await Task.sleep(nanoseconds: 100_000_000)  // Delay for 1.5 seconds
                                        playersData.roll += 1
                                        try   await Task.sleep(nanoseconds: 300_000_000)  // Delay for 1.5 seconds

                                        
                                    }catch{
                                        // todo make it jump to the right spot it should have gone by precalc
                                        print("well isn't that great")
                                    }
                                }
                               
                                hideAll = false
                            }
                            
                            currentPlayerAction = .none  // Set currentPlayerAction to .none
                        }
                    case .payToGetOutOfJail:
                        
                         Text("Not implemented")
                             .onAppear {
                                 Task {
                                     do {
                                         
                                         try  await Task.sleep(nanoseconds: 1_000_000_000)  // Delay for 1.5 seconds
                                         currentPlayerAction = .none
                                     }catch{
                                         print("well isn't that great")
                                     }
                                 }
                             }
                        
                    case .useGetOutOfJailFreeCard:
                       
                        Text("Not implemented")
                            .onAppear {
                                Task {
                                    do {
                                        
                                        try  await Task.sleep(nanoseconds: 1_000_000_000)  // Delay for 1.5 seconds
                                        currentPlayerAction = .none
                                    }catch{
                                        print("well isn't that great")
                                    }
                                }
                            }
                        
                    case .endTurn:
                        // Implement end turn action logic
                        // using the provided player instance
                        Text("Player Ended Turn").onAppear{currentPlayerAction = .none}
                        
                    case .none:
                        EmptyView()
                    }
                }
            }
//        }
    }
}

