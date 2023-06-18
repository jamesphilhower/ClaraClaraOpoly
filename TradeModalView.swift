import SwiftUI

struct TradeModalView: View {
    @Binding var isShowingModal: Bool
    let currentPlayerIndex: Int

    // Add your necessary properties and methods for trade handling
    @EnvironmentObject private var diceAnimation: DiceAnimationData

    @State private var selectedPlayer: Player?
    @State private var tradeAmount: Int = 0
    @State private var selectedProperties: [Property] = []
    @State private var isShowingConfirmationView = false

    var body: some View {
        if isShowingConfirmationView {
            TradeConfirmationView(
                isShowingModal: $isShowingModal,
                selectedPlayer: selectedPlayer,
                tradeAmount: tradeAmount,
                selectedProperties: selectedProperties
            )
        } else {
            VStack {
                Text("Trade Modal")
                    .font(.title)
                    .padding()
                
                // Player Toggle Buttons
                Text("Select Player:")
                // Add Toggle buttons for each player that isn't the current player
                
                // Horizontal Scroll View for Current Player's Owned Properties
                Text("Select Properties to Trade:")
                // Add a horizontal scroll view that displays all the current player's owned properties
                
                // Trade Amount Input
                Text("Enter Trade Amount:")
                // Add input boxes for trade amount
                
                // Offer Trade Button
                Button("Offer Trade") {
                    isShowingConfirmationView = true
                }
                .padding()
                
                // Cancel Button
                Button("Cancel") {
                    isShowingModal = false
                }
                .padding()
            }
        }
    }
}

struct TradeConfirmationView: View {
    @Binding var isShowingModal: Bool
    var selectedPlayer: Player?
    var tradeAmount: Int
    var selectedProperties: [Property]
    
    var body: some View {
        VStack {
            Text("Trade Confirmation")
                .font(.title)
                .padding()
            
            // Display selected trade details
            
            // Accept Trade Button
            Button("Accept") {
                // Implement logic for accepting the trade
                isShowingModal = false
            }
            .padding()
            
            // Offer Amendment Button
            Button("Offer Amendment") {
                // Implement logic for offering an amendment to the trade
                isShowingModal = false
            }
            .padding()
            
            // Reject Trade Button
            Button("Reject") {
                // Implement logic for rejecting the trade
                isShowingModal = false
            }
            .padding()
        }
    }
}
