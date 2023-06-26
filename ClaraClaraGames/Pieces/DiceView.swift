import SwiftUI

struct DiceView: View {
    @EnvironmentObject private var diceAnimation: DiceAnimationData
    
    var body: some View {
        VStack {
            if diceAnimation.isFlashing { // Display the dice view with cycling numbers during flashing animation
                if diceAnimation.isTwoDice {
                    withAnimation(.default) {
                        HStack {
                            DieView(number: diceAnimation.flashingNumbers[0], color: diceAnimation.diceColor)
                            DieView(number: diceAnimation.flashingNumbers[1], color: diceAnimation.diceColor)
                        }
                    }
                } else {
                    withAnimation(.default) {
                        DieView(number: diceAnimation.flashingNumbers[0], color: diceAnimation.diceColor)
                    }
                }
            }
        }
    }
}

struct DieView: View {
    let number: Int
    let color: Color
    
    var body: some View {
        Image(systemName: "die.face.\(number)")
            .font(.system(size: 100, weight: .bold))
            .frame(width: 120, height: 120)
            .foregroundColor(.white)
            .background(color)
            .cornerRadius(10)
    }
}
