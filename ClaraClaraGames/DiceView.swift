import SwiftUI

struct DiceView: View {
    @EnvironmentObject private var diceAnimation: DiceAnimationData
    
    var body: some View {
        VStack {
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

struct DieView: View {
    let number: Int
    let color: Color
    
    var body: some View {
//        Text("\(number)")
//            .font(.system(size: 100, weight: .bold))
//            .frame(width: 120, height: 120)
//            .foregroundColor(.white)
//            .background(color)
//            .cornerRadius(10)
   

                Image(systemName: "die.face.\(number)")
                    .font(.system(size: 100, weight: .bold))
                    .frame(width: 120, height: 120)
                    .foregroundColor(.white)
                    .background(color)
                    .cornerRadius(10)
            

    }
}
