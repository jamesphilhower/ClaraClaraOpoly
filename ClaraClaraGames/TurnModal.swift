import SwiftUI

struct PlayerTurnButtonView {
    var isEnabled: Bool
    var checkEnabled: () -> Bool
    var action: () -> Void
    var text: String
}

struct PlayerTurnModalView: View {
    @Binding var isShowingModal: Bool
    let currentPlayerIndex: Int

    @EnvironmentObject private var diceAnimation: DiceAnimationData
    @EnvironmentObject private var playersData: PlayersData


    @State private var buttons: [PlayerTurnButtonView] = [
        PlayerTurnButtonView(
            isEnabled: true,
            checkEnabled: { true },
            action: {
                // Implement action for Button 1
            },
            text: "Button 1"
        ),
        PlayerTurnButtonView(
            isEnabled: false,
            checkEnabled: { false },
            action: {
                // Implement action for Button 2
            },
            text: "Button 2"
        ),
        // Add more buttons as needed
    ]
    
    var body: some View {
        
        BaseModalView {
                   VStack {
                       Text("Player Turn Modal")
                           .font(.title)
                           .padding()
                       
                       // Content specific to PlayerTurnModalView
                       Text("Current Player: \(playersData.players[currentPlayerIndex].name)")
                       
                       Button(action: {
                           Task {
                               let rollResult = await diceAnimation.startDiceAnimationWrapper()
                               // Use the rollResult in your logic
                               print("Roll Result: \(rollResult)")
                           }
                       }) {
                           Text("Start Flashing")
                               .font(.headline)
                               .foregroundColor(.white)
                               .padding()
                               .background(Color.blue)
                               .cornerRadius(10)
                       }
                       .padding()

                   }
               }
        
        VStack {
            
            ForEach(buttons.indices, id: \.self) { index in
                if buttons[index].isEnabled {
                    Button(action: buttons[index].action) {
                        Text(buttons[index].text)
                    }
                    .padding()
                }
            }
        }
        .onChange(of: currentPlayerIndex) { newValue in
            for index in buttons.indices {
                buttons[index].isEnabled = buttons[index].checkEnabled()
            }
        }
    }
}

