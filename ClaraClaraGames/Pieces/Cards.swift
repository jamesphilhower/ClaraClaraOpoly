import SwiftUI

let bothCards: [String: gameCard] = [
    "Advance to Start": gameCard(text: "Advance to Start.  +$200.", action: { player in
        print("move start")
        await player.movePlayerToProperty(propertyName: "Start")
    }),
    "Get out of Jail Free": gameCard(text: "Get well wish", action: { player in
        player.getOutOfJailCards += 1
    }),
    "Capex": gameCard(text: "Thieves and vandals run through the street. For each house, pay $25. For each hotel, pay $100.", action: { player in
        player.payForRepairs()
    }),
    "Get Sick": gameCard(text: "Go directly to Hospital.", action: { player in
        player.goToJail()
    }),
]

let chanceCards: [String: gameCard] = [
    
    "Advance to Facemask": gameCard(text: "Advance to Facemask.", action: { player in
        await player.movePlayerToProperty(propertyName: "Facemask")
    }),
    "Advance to Graduation": gameCard(text: "Advance to Graduation.", action: { player in
        await player.movePlayerToProperty(propertyName: "Graduation")
    }),
    "Advance to nearest Utility": gameCard(text: "Advance token to nearest Utility", action: { player in
        await player.moveToNearest(propertyGroup: "utilities")
    }),
    "Advance to nearest Railroad": gameCard(text: "Advance token to the nearest Railroad", action: { player in
        await player.moveToNearest(propertyGroup: "rr")
    }),
    "Find Money on The Ground": gameCard(text: "Find $50 on The Ground", action: { player in
        player.collectFromBank(50)
    }),
    "Go back 3 spaces": gameCard(text: "You forgot your briefcase. Go back 3 spaces", action: { player in
        await player.moveBackwards(3)
    }),
    "Pay poor tax": gameCard(text: "Buy Prescription.", action: { player in
        player.payFee(15)
    }),
    "Advance to R1": gameCard(text: "Advance to R1", action: { player in
        await player.movePlayerToProperty(propertyName: "R1")
    }),
    "Advance to Congress": gameCard(text: "Advance to Congress", action: { player in
        await player.movePlayerToProperty(propertyName: "Congress")
    }),
    "Bribe the witnesses": gameCard(text: "Bribe the witnesses -$50/each", action: { player in
        player.payOtherPlayers(50)
    }),
    "Startup": gameCard(text: "Your startup equity vested. +$150", action: { player in
        player.collectFromBank(150)
    }),
    "The court rules": gameCard(text: "You give up your seat on an overbooked flight. +$100", action: { player in
        player.collectFromBank(100)
    }),
]

let communityChestCards: [String: gameCard] = [
    "Dogecoin": gameCard(text: "Tax return loophole in your favor.  +$200.", action: { player in
        player.collectFromBank(200)
    }),
    "Hospital bed fees": gameCard(text: "Hospital bed fees. -$50.", action: { player in
        player.payFee(50)
    }),
    "From sale of stock you get $50": gameCard(text: "Class action lawsuit settles. +$50.", action: { player in
        player.collectFromBank(50)
    }),
    "Grand Opera Night. Collect $50 from every player for opening night seats": gameCard(text: "Venmoes for dinner last month come in. +10/each", action: { player in
        player.payOtherPlayers(50)
    }),
    "Holiday Fund matures. Receive $100": gameCard(text: "Startup equity matures. +$100.", action: { player in
        player.collectFromBank(100)
    }),
    "IRS approves business deductions": gameCard(text: "IRS approves business deductions. +$20.", action: { player in
        player.collectFromBank(20)
    }),
    "It's your birthday. Collect $10 from every player": gameCard(text: "Chinese New Year. +$10/each", action: { player in
        player.payOtherPlayers(10)
    }),
    "Unemployment backpay check": gameCard(text: "The DOL backpays your unemployment: +$100.", action: { player in
        player.collectFromBank(100)
    }),
    "Hit by uninsured motorist": gameCard(text: "Hit by uninsured motorist -$100.", action: { player in
        player.payFee(100)
    }),
    "Tuition Interest is due": gameCard(text: "Tuition Interest Payment. -$50.", action: { player in
        player.payFee(50)
    }),
    "Your selfie sells for $25": gameCard(text: "Bring your coins to Coinstar. +$25", action: { player in
        player.collectFromBank(25)
    }),
    "You have won second prize in a beauty contest – Collect $10": gameCard(text: "An Amazon seller pays you for a review. +$10", action: { player in
        player.collectFromBank(10)
    }),
    "You inherit $100": gameCard(text: "Your stimulus check arrives. +$100.", action: { player in
        player.collectFromBank(100)
    }),
]

class CardsData: ObservableObject {
    var chanceDrawPile: [gameCard]
    @Published var chanceDrawIndex = 0
    var communityChestDrawPile: [gameCard]
    @Published var communityChestDrawIndex = 0

    init(){
        self.chanceDrawPile = (Array(chanceCards.values) + Array(bothCards.values)).shuffled()
        self.communityChestDrawPile = (Array(communityChestCards.values) + Array(bothCards.values)).shuffled()
    }
}

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
    var position: CGPoint
    
    var cardColor: Color
    let iconName: String
    var drawIndex: Int
    var drawPile: [gameCard]
    
    func buildRectangleStack(color: Color, degrees: [Double], iconName: String) -> some View {
        ZStack {
            ForEach(degrees.indices, id: \.self) { index in
                ZStack {
                    Rectangle()
                        .foregroundColor(color)
                        .frame(width: index == degreesOfCards.count - 1 && isFlipped ? UIScreen.main.bounds.width * 0.7 : 80, height: index == degreesOfCards.count - 1 && isFlipped ? UIScreen.main.bounds.width * 0.35 : 40)
                        .shadow(radius: shadowRadius(for: degrees[index]))
                        .onTapGesture {
                            if index == degreesOfCards.count - 1 && isFlipped {
                                withAnimation {
                                    isFlipped = false
                                }
                            }
                        }
                    
                    if index == degreesOfCards.count - 1 {
                        if isFlipped {
                            Text(drawPile[drawIndex].text)
                                .font(.body)
                                .lineLimit(nil) // Allow unlimited lines
                                .foregroundColor(.white)
                                .frame(maxWidth: 70)
                                .rotated(.degrees(180))
                                .scaleEffect(x: -1)
                                .zIndex(1)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        if isFlipped {
                                            withAnimation {
                                                isFlipped = false
                                            }
                                        }
                                    }
                                }
                        } else {
                            Image(systemName: iconName)
                                .zIndex(1)
                        }
                    } else {
                        Image(systemName: iconName)
                            .zIndex(1)
                    }
                }
                .animation(.default)
                .rotationEffect(index == degreesOfCards.count - 1 && isFlipped ? .degrees(0) : .degrees(degrees[index]))
                .rotation3DEffect(.degrees(index == degreesOfCards.count - 1 && isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                .position(index == degreesOfCards.count - 1 && isFlipped ? cardPosition : position)
                .zIndex(index == degreesOfCards.count - 1 && isFlipped ? 10 : Double(degrees.count - index))
                .offset(y: index == degreesOfCards.count - 1 && !isFlipped ? -20 * Double(degrees.count - index - 1) : 0)
                .onChange(of: isFlipped) { newValue in
                    if !newValue {
                        withAnimation {
                            degreesOfCards.shuffle()
                        }
                    }
                }
            }
        }
        .onTapGesture {
            withAnimation {
                isFlipped = true
            }
        }
    }

    


    var body: some View {
        buildRectangleStack(color: cardColor, degrees: degreesOfCards, iconName: iconName)
            .onAppear {
                withAnimation {
                    cardPosition = CGPoint(x: UIScreen.main.bounds.width * 0.15, y: UIScreen.main.bounds.width  * 0.25)
                }
            }
            .onChange(of: drawIndex) { _ in
                withAnimation {
                    cardPosition = CGPoint(x: UIScreen.main.bounds.width  * 0.35 + 4, y: UIScreen.main.bounds.width  * 0.25)
                    isFlipped = true
                }
            }
    }
}

struct OrangeCards: View {
    @ObservedObject var cards: CardsData
    @State var degreesOfCards: [Double] = [46, 41, 45, 43, 48, 47]
    let geometry: GeometryProxy
    
    
    var body: some View {
        CardGroupBaseView(degreesOfCards: $degreesOfCards, position: CGPoint(x: 0.8 * geometry.size.width, y: 0.3 * geometry.size.height), cardColor: .orange, iconName: "ticket", drawIndex: cards.chanceDrawIndex, drawPile: cards.chanceDrawPile)
    }
}


struct YellowCards: View {
    @ObservedObject var cards: CardsData
    @State var degreesOfCards: [Double] = [41, 47, 40, 43, 44, 42]
    let geometry: GeometryProxy

    var body: some View {
        CardGroupBaseView(degreesOfCards: $degreesOfCards, position:  CGPoint(x: 0.2 * geometry.size.width, y: 0.75 * geometry.size.height), cardColor: .yellow, iconName: "chart.xyaxis.line", drawIndex: cards.communityChestDrawIndex, drawPile: cards.communityChestDrawPile)
    }
}

struct CardsView: View {
    @EnvironmentObject var cards: CardsData
    var body: some View {
        GeometryReader { geometry in
            OrangeCards(cards: cards, geometry: geometry)
            YellowCards(cards: cards, geometry: geometry)
        }.animation(.default)
    }
}

func shadowRadius(for degree: Double) -> CGFloat {
    switch degree {
    case 48, 42, 44:
        return 3
    case 46, 47:
        return 2
    default:
        return 1
    }
}


func generateRandomView() -> some View {
    let rotationProbabilities: [Double] = [0.4, 0.3, 0.2, 0.1] // Probabilities for different rotation values
    let shadowProbabilities: [Double] = [0.4, 0.3, 0.2, 0.1] // Probabilities for different shadow radii
    
    let randomRotationIndex = weightedRandomIndex(probabilities: rotationProbabilities)
    let randomShadowIndex = weightedRandomIndex(probabilities: shadowProbabilities)
    
    return Rectangle()
        .foregroundColor(.orange)
        .frame(width: 80, height: 40)
        .rotationEffect(.degrees(Double(randomRotationIndex * 5)))
        .shadow(radius: Double(randomShadowIndex))
}

func weightedRandomIndex(probabilities: [Double]) -> Int {
    let sum = probabilities.reduce(0, +)
    let randomValue = Double.random(in: 0..<sum)
    var cumulativeProbability = 0.0
    
    for (index, probability) in probabilities.enumerated() {
        cumulativeProbability += probability
        if randomValue < cumulativeProbability {
            return index
        }
    }
    
    return probabilities.count - 1
}
