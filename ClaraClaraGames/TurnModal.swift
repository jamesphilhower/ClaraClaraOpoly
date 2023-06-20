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
                    hasRolled = true
                    currentPlayer.consecutiveTurnsInJail += 1
                    if currentPlayer.consecutiveTurnsInJail >= 3 {
                        currentPlayer.goToJail()
                    }
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
                    currentPlayer.consecutiveTurnsInJail = 0
                    currentPlayer.inJail = false
                    currentPlayer.payToGetOutOfJail()
                },
                content: {
                    Text("Pay to Get Out of Jail")
                }
            ),
            "UseGetOutOfJailFreeCard": PlayerTurnButton(
                isEnabled: currentPlayer.inJail && currentPlayer.getOutOfJailCards > 0,
                action: {
                    currentPlayerAction = .useGetOutOfJailFreeCard
                    currentPlayer.consecutiveTurnsInJail = 0
                    currentPlayer.inJail = false
                    currentPlayer.getOutOfJailCards -= 1
                },
                content: {
                    Text("Use Get Out of Jail Free Card")
                }
            ),
            "EndTurn": PlayerTurnButton(
                isEnabled: currentPlayer.inJail && currentPlayer.consecutiveTurnsInJail < 3 && hasRolled,
                action: {
                    currentPlayerAction = .endTurn
                    endTurnAndShowPopup()
                },
                content: {
                    Text("End Turn")
                }
            )
        ]
        
        
        BaseModalView {
            ZStack {
                VStack {
                    Text("Current Player: \(currentPlayer.name)")
                    
                    ForEach(buttons.filter { $0.value.isEnabled }, id: \.key) { key, button in
                        button
                    }
                }.disabled(currentPlayerAction != .none)
                
                switch currentPlayerAction {
                case .trade:
                    // Implement trade action logic
                    // using the provided player instance
                    TradeModalView(currentPlayerAction: $currentPlayerAction, currentPlayer: currentPlayer)
                    
                case .manageProperties:
                    // Implement manage properties action logic
                    // using the provided player instance
                    ManagePropertiesModal(currentPlayerAction: $currentPlayerAction, currentPlayer: currentPlayer)
                    
                case .roll:
                    DiceView()
                    
                case .payToGetOutOfJail:
                    DiceView()
                    
                case .useGetOutOfJailFreeCard:
                    // Implement use get out of jail free card action logic
                    DiceView()

                case .endTurn:
                    // Implement end turn action logic
                    // using the provided player instance
                    Text("Player Ended Turn").onAppear{currentPlayerAction = .none}
                    
                case .none:
                    EmptyView()
                }
                
                
            }
        }
    }
}

