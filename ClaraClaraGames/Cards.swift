import SwiftUI

struct gameCard: Equatable {
    let text: String
    let action: (Player)async -> Void
    
    static func ==(lhs: gameCard, rhs: gameCard) -> Bool {
        return lhs.text == rhs.text && lhs.action as AnyObject === rhs.action as AnyObject
    }
}

struct CardGroupBaseView: View {
    
    @Binding var degreesOfCards: [Double]
    @State private var cardPosition: CGPoint = .zero
    @State private var isFlipped: Bool = false
    var rotationAngle: Double
    
    var position: CGPoint
    
    var cardColor: Color
    let iconName: String
    var drawIndex: Int
    var drawPile: [gameCard]
    var geometry: GeometryProxy
    
    private func shadowRadius(for degree: Double) -> CGFloat {
        switch degree {
        case 48, 42, 44:
            return 3
        case 46, 47:
            return 2
        default:
            return 1
        }
    }
    
    func buildRectangleStack(color: Color, degrees: [Double], iconName: String) -> some View {
        ZStack {
            ForEach(degrees.indices, id: \.self) { index in
                withAnimation(.default) {
                    ZStack {
                        Rectangle()
                            .foregroundColor(color)
                            .frame(width: 80, height: 40)
                            .shadow(radius: shadowRadius(for: degrees[index]))
                        Image(systemName: iconName)
                                .zIndex(1)
                    }
                    .rotated(.degrees(rotationAngle == 90 || rotationAngle == 270 ? -rotationAngle : rotationAngle))
                    .rotationEffect(.degrees(degrees[index]))
                    .position(position)
                    .onChange(of: isFlipped) { newValue in
                        if !newValue {
                            withAnimation {
                                degreesOfCards.shuffle()
                            }
                        }
                    }
                }
            }
            
            ZStack {
                Rectangle()
                    .foregroundColor(color)
                    .frame(width: isFlipped ? UIScreen.main.bounds.width * 0.7 : 80, height: isFlipped ? UIScreen.main.bounds.width * 0.35 : 40)
                    .shadow(radius: 1)
                    .onTapGesture {
                        if isFlipped {
                            withAnimation {
                                isFlipped = false
                            }
                        }
                    }
                
                    if isFlipped {
                        Text(drawPile[drawIndex].text)
                            .font(.custom("AmericanTypewriter", size: 16))
                            .lineLimit(nil) // Allow unlimited lines
                            .frame(width: geometry.size.width * 0.7)
                            .foregroundColor(.white)
                            .scaleEffect(x: -1)
                            .zIndex(1)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    if isFlipped {
                                        withAnimation {
                                            isFlipped = false
                                        }
                                    }
                                }
                            }
                    }
                    else {
                        Image(systemName: iconName)
                            .zIndex(1)
                    }
            }
            .rotated(.degrees(rotationAngle == 90 || rotationAngle == 270 ? -rotationAngle : rotationAngle))
            .rotationEffect(isFlipped ? .degrees(0) : .degrees(degrees.randomElement() ?? 45))
            .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
            .position(isFlipped ? cardPosition : position)
        }
    }
    
    var body: some View {
        buildRectangleStack(color: cardColor, degrees: degreesOfCards, iconName: iconName)
            .onChange(of: drawIndex) { _ in
                withAnimation {
                    
                    switch (rotationAngle, geometry.size) {
                    case   (90, _): // chance good
                        cardPosition = CGPoint(x: geometry.size.width / 4, y: geometry.size.height / 2)
                    case  (180, _):
                        cardPosition = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 4)
                    case  (270, _): // chance high
                        cardPosition = CGPoint(x: geometry.size.width * 0.75, y: geometry.size.height / 2)
                    case    (0, _): // chance good
                        cardPosition = CGPoint(x: geometry.size.width / 2, y: geometry.size.height * 0.75)
                    default:
                        print("YEAH IDK BUDDY NOT THE CORRECT ONE")
                        cardPosition = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    }
                    isFlipped = true
                }
            }
    }
}

struct OrangeCards: View {
    @ObservedObject var cards: CardsData
    @State var degreesOfCards: [Double] = [46, 41, 45, 43, 48, 47]
    let geometry: GeometryProxy
    var rotationAngle: Double
    
    
    var body: some View {
        CardGroupBaseView(degreesOfCards: $degreesOfCards, rotationAngle: rotationAngle, position: CGPoint(x: 0.8 * geometry.size.width, y: 0.3 * geometry.size.height), cardColor: .orange, iconName: "ticket", drawIndex: cards.chanceDrawIndex, drawPile: cards.chanceDrawPile, geometry: geometry)
    }
}


struct YellowCards: View {
    @ObservedObject var cards: CardsData
    @State var degreesOfCards: [Double] = [41, 47, 40, 43, 44, 42]
    let geometry: GeometryProxy
    var rotationAngle: Double
    
    
    var body: some View {
        CardGroupBaseView(degreesOfCards: $degreesOfCards, rotationAngle: rotationAngle, position:  CGPoint(x: 0.2 * geometry.size.width, y: 0.75 * geometry.size.height), cardColor: .yellow, iconName: "chart.xyaxis.line", drawIndex: cards.communityChestDrawIndex, drawPile: cards.communityChestDrawPile, geometry: geometry)
    }
}

struct CardsView: View {
    @EnvironmentObject var cards: CardsData
    var rotationAngle: Double
    @State var chanceZIndex: Double = 0
    @State var chestZIndex: Double = 0
    var body: some View {
        withAnimation(.default)
        {
            GeometryReader { geometry in
                OrangeCards(cards: cards, geometry: geometry, rotationAngle: rotationAngle)
                    .onChange(of: cards.chanceDrawIndex){_ in
                        chanceZIndex = 1
                        chestZIndex = 0
                    }
                    .zIndex(chanceZIndex)
                YellowCards(cards: cards, geometry: geometry, rotationAngle: rotationAngle)
                    .onChange(of: cards.communityChestDrawIndex){_ in
                        chanceZIndex = 0
                        chestZIndex = 1
                    }
                    .zIndex(chestZIndex)

            }
        }
    }
}
