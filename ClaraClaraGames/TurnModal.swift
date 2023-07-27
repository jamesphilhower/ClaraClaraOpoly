import SwiftUI

struct PlayerTurnButton<Content: View>: View {
    let isEnabled: Bool
    let action: () -> Void
    let content: Content
    let iconName: String
    
    init(isEnabled: Bool, action: @escaping () -> Void, @ViewBuilder content: () -> Content, iconName: String) {
        self.isEnabled = isEnabled
        self.action = action
        self.content = content()
        self.iconName = iconName
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: iconName)
                    .font(.system(size: 32))
                    .frame(height: 40)
                    .padding(8)
                    .foregroundColor(.black)
                    .frame(width: 50)
                    .background(
                        Circle()
                            .fill(.white.opacity(0.75))
                    )
                content.foregroundColor(.black).font(.system(size: 10))
            }
        }
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
                },
                iconName: "dice"
            ),
            PlayerTurnButton(
                isEnabled: true,
                action: {
                    currentPlayerAction = .trade
                },
                content: {
                    Text("Trade")
                },
                iconName: "arrow.up.arrow.down"
            ),
            PlayerTurnButton(
                isEnabled: currentPlayer.ownsProperties,
                action: {
                    currentPlayerAction = .manageProperties
                },
                content: {
                    Text("Manage\nProperties")
                },
                iconName: "gear"
            ),
            PlayerTurnButton(
                isEnabled: currentPlayer.inJail,
                action: {
                    currentPlayerAction = .payToGetOutOfJail
                    currentPlayer.payToGetOutOfJail()
                },
                content: {
                    Text("Pay to Get Out of Jail")
                },
                iconName: "dollarsign"
            ),
            PlayerTurnButton(
                isEnabled: currentPlayer.inJail && currentPlayer.getOutOfJailCards > 0,
                action: {
                    currentPlayerAction = .useGetOutOfJailFreeCard
                    currentPlayer.useGetOutOfJailFreeCard()
                },
                content: {
                    Text("Use Get Out of Jail Free Card")
                },
                iconName: "gift"
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
                },
                iconName: "arrow.clockwise"
            )
        ]

        
        if !hideAll {
//            BaseModalView {
            ZStack(alignment: .top) {
                HStack(alignment: .top, spacing:20) {
                        ForEach(buttons.indices) { index in
                            if buttons[index].isEnabled {
                                buttons[index]
                            }
                        }
                }.frame(height: 180).disabled(currentPlayerAction != .none)
                    
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

