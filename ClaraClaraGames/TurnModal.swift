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
    @EnvironmentObject private var cards: CardsData

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
        
        let buttons: [PlayerTurnButton<Text>] = [
            PlayerTurnButton(
                isEnabled: !hasRolled || currentPlayer.consecutiveTurnsInJail >= 3,
                action: {
                    currentPlayerAction = .roll
                },
                content: {
                    Text("Roll")
                }
            ),
            PlayerTurnButton(
                isEnabled: true,
                action: {
                    currentPlayerAction = .trade
                },
                content: {
                    Text("Trade")
                }
            ),
            PlayerTurnButton(
                isEnabled: currentPlayer.ownsProperties,
                action: {
                    currentPlayerAction = .manageProperties
                },
                content: {
                    Text("Manage Properties")
                }
            ),
            PlayerTurnButton(
                isEnabled: currentPlayer.inJail,
                action: {
                    currentPlayerAction = .payToGetOutOfJail
                    playersData.players[currentPlayerIndex].consecutiveTurnsInJail = 0
                    playersData.players[currentPlayerIndex].inJail = false
                    playersData.players[currentPlayerIndex].payToGetOutOfJail()
                },
                content: {
                    Text("Pay to Get Out of Jail")
                }
            ),
            PlayerTurnButton(
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
            PlayerTurnButton(
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
                    VStack(spacing:-20) {
                        Text("Current Player: \(currentPlayer.name)")
                        
                        ForEach(buttons.indices) { index in
                            if buttons[index].isEnabled {
                                buttons[index]
                            }
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
                                let r1 = rolls[0]
                                let r2 = rolls[1]
                                if r1 == r2 {
                                    print("DOUBLES")
                                    doublesInARow += 1

                                    if doublesInARow >= 3 {
                                        playersData.players[currentPlayerIndex].goToJail()
                                    }
                                } else {
                                    hasRolled = true
                                }
                                

                                await currentPlayer.move(spaces: r1 + r2)
                                
                                print("done moving, now gonna wait a sec")
                                do {
                                    try  await Task.sleep(nanoseconds: 500_000_000)
                                }catch{
                                    print("oopsie tehre")

                                }

                                
                                await currentPlayer.handleLandingOnSpace(roll: r1 + r2)

                                //await currentPlayer.executeCards()
                                print("waiting to force draw a card")
                                do {
                                    try  await Task.sleep(nanoseconds: 1500_000_000)
                                }catch{
                                    print("oopsie tehre")

                                }
                                await currentPlayer.drawCard(Int.random(in: 0...10) < 5 ? "chance" : "chest")
                               
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

