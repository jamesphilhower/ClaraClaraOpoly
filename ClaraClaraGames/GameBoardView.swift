import SwiftUI

struct gameCard {
    let text: String
    let action: () -> Void
}

struct GameCardBaseView: View {
    
    let cardColor: Color
    var body: some View {
        Rectangle().frame(width: 80, height:40).rotationEffect(.degrees(45)).foregroundColor(cardColor)
    }
}

struct CardGroupBaseView: View {
    
    let text: String
    var cardColor: Color
    let iconName: String
    var drawPile: [gameCard]
    var discardPile: [gameCard]
        
    var body: some View {
        GameCardBaseView(cardColor: cardColor)
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


struct GameBoardView: View {
    var selectedGameBoard: String
    @EnvironmentObject private var playersData: PlayersData
    @State private var regenerateBoard = false
    @State  var cellCenters: [Int: CGPoint] = [:] // Dictionary to store the centers of the cell views
    @State private var originalIndex: Int = 0
    @State private var newIndex: Int = 0
    
    var body: some View {
        GeometryReader { geometry in
            if selectedGameBoard == "Traditional" {
                TraditionalGameBoardView(geometry: geometry, cellCenters: $cellCenters)
                    .overlay(
                        ForEach(playersData.players, id: \.self){ player in
                            
                            let index = player.location
                            let x = cellCenters[index]!.x
                            let y = cellCenters[index]!.y
                            
                            Circle().frame(width: 14, height: 14).position(x: x, y: y).foregroundColor(.blue).animation(.linear(duration: 0.3))
                        }
                        
                    )
                    .overlay(DiceView())
                    .shadow(radius: 1)
                    .cornerRadius(3)
            } else if selectedGameBoard == "InfinityGameBoardView" {
                InfinityGameBoardView()
            } else if selectedGameBoard == "ShootsAndLadders" {
                ShootsAndLaddersGameBoardView()
            }
        }
        
    }
}

import SwiftUI

struct SkylineView: View {
    let scaleFactor: CGFloat
    @State var moveDown = 0
    
    func getRandomColor()->Color{
        let colors: [Color] = [
            //            .black,
            .gray,
        ]
        return colors.randomElement()!
    }
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: -60) {
                    HStack(spacing: 20) {
                        ForEach(0..<6) { _a in
                            let buildingSize = CGSize(width: CGFloat.random(in: 60...100) * scaleFactor, height: CGFloat.random(in: 160...200))
                            let randomBuildingImage = getRandomBuildingImage()
                            
                            Image(systemName: randomBuildingImage)
                                .resizable()
                                .offset(x: CGFloat.random(in: 10...20), y: CGFloat.random(in: 10...20))
                                .aspectRatio(contentMode: .fit)
                                .frame(width: buildingSize.width, height: buildingSize.height)
                                .foregroundColor(getRandomColor())
                        }
                    }
                    
                    HStack(spacing: 20) {
                        ForEach(0..<6) { _ in
                            let buildingSize = CGSize(width: CGFloat.random(in: 60...100) * scaleFactor, height: CGFloat.random(in: 160...200))
                            let randomBuildingImage = getRandomBuildingImage()
                            
                            Image(systemName: randomBuildingImage)
                                .resizable()
                                .offset(x: CGFloat.random(in: 10...20),y: CGFloat.random(in: 10...20))
                                .aspectRatio(contentMode: .fit)
                                .frame(width: buildingSize.width, height: buildingSize.height)
                                .foregroundColor(getRandomColor())
                        }
                    }
                    
                    HStack(spacing: 20) {
                        ForEach(0..<6) { _ in
                            let buildingSize = CGSize(width: CGFloat.random(in: 60...100) * scaleFactor, height: CGFloat.random(in: 160...200))
                            let randomBuildingImage = getRandomBuildingImage()
                            
                            Image(systemName: randomBuildingImage)
                                .resizable()
                                .offset(x: CGFloat.random(in: 10...20), y: CGFloat.random(in: 10...20))
                                .aspectRatio(contentMode: .fit)
                                .frame(width: buildingSize.width, height: buildingSize.height)
                                .foregroundColor(getRandomColor())
                        }
                    }
                }.frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height).clipped()
                
                    
                    VStack {
                        
                        Text("Clara").font(.system(size: 90)).fontWeight(.heavy).foregroundColor(.black).offset(x: 0)//.shadow(color: .black, radius: 10, x: 10, y: 10)
                        Text("Clara").font(.system(size: 80)).fontWeight(.bold).foregroundColor(.black)//.shadow(color: .black, radius: 10, x: 10, y: 10)
                        Text("Opoly").font(.system(size: 70)).fontWeight(.semibold).foregroundColor(.black).offset(x: 45)//.shadow(color: .black, radius: 10, x: 10, y: 10)
                        
                    }
                
                
                
                ZStack {
                    Rectangle().foregroundColor(.orange).frame(width: 80, height:40).shadow(radius: 1)
                    Rectangle().foregroundColor(.orange).frame(width: 80, height:40).rotationEffect(.degrees(46)).shadow(radius: 2)
                    Rectangle().foregroundColor(.orange).frame(width: 80, height:40).rotationEffect(.degrees(47)).shadow(radius: 1)
                    Rectangle().foregroundColor(.orange).frame(width: 80, height:40).rotationEffect(.degrees(43)).shadow(radius: 2)
                    Rectangle().foregroundColor(.orange).frame(width: 80, height:40).rotationEffect(.degrees(48)).shadow(radius: 3)
                    Rectangle().foregroundColor(.orange).frame(width: 80, height:40).rotationEffect(.degrees(47)).shadow(radius: 1)
                }.position(x: 0.80 * geometry.size.width , y: 0.3 * geometry.size.height  )
                
                Group {
                    Rectangle().foregroundColor(.yellow).frame(width: 80, height:40).rotationEffect(.degrees(41)).shadow(radius: 1)
                    Rectangle().foregroundColor(.yellow).frame(width: 80, height:40).rotationEffect(.degrees(47)).shadow(radius: 2)
                    Rectangle().foregroundColor(.yellow).frame(width: 80, height:40).rotationEffect(.degrees(42)).shadow(radius: 3)
                    Rectangle().foregroundColor(.yellow).frame(width: 80, height:40).rotationEffect(.degrees(41)).shadow(radius: 1)
                    Rectangle().foregroundColor(.yellow).frame(width: 80, height:40).rotationEffect(.degrees(44)).shadow(radius: 1)
                    Rectangle().foregroundColor(.yellow).frame(width: 80, height:40).rotationEffect(.degrees(42)).shadow(radius: 1)
                }.position(x: 0.2*geometry.size.width , y: 0.75 * geometry.size.height  )
                
                
            }
        }
    }
    
    func getRandomBuildingImage() -> String {
        let buildingImages = [
            "building.fill",
            "building",
            "building.2.fill",
            "building.columns",
        ]
        
        return buildingImages.randomElement() ?? "building.2.fill"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

private struct SizeKey: PreferenceKey {
    static let defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

extension View {
    func captureSize(in binding: Binding<CGSize>) -> some View {
        overlay(GeometryReader { proxy in
            Color.clear.preference(key: SizeKey.self, value: proxy.size)
        })
            .onPreferenceChange(SizeKey.self) { size in binding.wrappedValue = size }
    }
}

struct Rotated<Rotated: View>: View {
    var view: Rotated
    var angle: Angle

    init(_ view: Rotated, angle: Angle = .degrees(-90)) {
        self.view = view
        self.angle = angle
    }

    @State private var size: CGSize = .zero

    var body: some View {
        // Rotate the frame, and compute the smallest integral frame that contains it
        let newFrame = CGRect(origin: .zero, size: size)
            .offsetBy(dx: -size.width/2, dy: -size.height/2)
            .applying(.init(rotationAngle: CGFloat(angle.radians)))
            .integral

        return view
            .fixedSize()                    // Don't change the view's ideal frame
            .captureSize(in: $size)         // Capture the size of the view's ideal frame
            .rotationEffect(angle)          // Rotate the view
            .frame(width: newFrame.width,   // And apply the new frame
                   height: newFrame.height)
    }
}

extension View {
    func rotated(_ angle: Angle = .degrees(-90)) -> some View {
        Rotated(self, angle: angle)
    }
}

struct TraditionalGameBoardView: View {
    
    let boardSize: CGFloat = 11 // Total number of cells on the board
    let horizontalSpaceRatio: CGFloat = 0.7 // Ratio of width for horizontal spaces
    let verticalSpaceRatio: CGFloat = 0.7 // Ratio of height for vertical spaces
    let geometry: GeometryProxy
    @Binding  var cellCenters: [Int: CGPoint]
    
    func generateCenters()->[Int: CGPoint]{
        
        let coordBase = geometry.frame(in: .global)
        let verticalSize: CGSize = calculateNonCornerCellSize(geometry, horizontal: false)
        let horizontalSize: CGSize = calculateNonCornerCellSize(geometry, horizontal: true)
        let cornerSize: CGSize = calculateCornerCellSize(geometry)
        
        var cellCenters: [Int: CGPoint] = [:] // Dictionary to store the centers of the cell views
        
        func incrementBottomRight(_ increment: CGSize){
            if vertical {
                curBottomRight.y += increment.height
            }
            else {
                curBottomRight.x += increment.width
            }
        }
        
        func resetTopLeft(){
            if vertical {
                curTopLeft.y = curBottomRight.y
            } else {
                curTopLeft.x = curBottomRight.x
            }
        }
        
        func addMidpoint(){
            let midPoint: CGPoint = CGPoint(x: (curTopLeft.x + curBottomRight.x) / 2, y: (curTopLeft.y + curBottomRight.y) / 2)
            cellCenters[index] = midPoint
        }
        
        // Top row
        var index: Int = 21
        var vertical: Bool = false
        var curTopLeft = CGPoint(x: 10, y: 0)
        var curBottomRight = CGPoint(x: 10 + cornerSize.width , y: cornerSize.height)
        addMidpoint()
        resetTopLeft()
        for loopIndex in (22..<31) {
            index = loopIndex
            incrementBottomRight(horizontalSize)
            addMidpoint()
            resetTopLeft()
        }
        index = 31
        incrementBottomRight(cornerSize)
        addMidpoint()
        
        // Left Column
        curTopLeft.x = 10 + coordBase.minX
        curTopLeft.y = cornerSize.height //+ coordBase.minY
        curBottomRight.x = 10 + cornerSize.width
        vertical = true
        for loopIndex in (12..<21).reversed(){
            index = loopIndex
            incrementBottomRight(verticalSize)
            addMidpoint()
            resetTopLeft()
        }
        index = 11
        incrementBottomRight(cornerSize)
        addMidpoint()
        //Right Column
        curTopLeft.x = geometry.frame(in: .global).maxX - 10 - cornerSize.width
        curTopLeft.y = cornerSize.height // move down height of corner
        curBottomRight.x = geometry.frame(in: .global).maxX - 10 // move to right side minus padding
        curBottomRight.y = cornerSize.height
        for loopIndex in (32..<41){
            index = loopIndex
            incrementBottomRight(verticalSize)
            addMidpoint()
            resetTopLeft()
        }
        // Bottom Row
        // Bottom Right
        index = 1
        incrementBottomRight(cornerSize)
        addMidpoint()
        vertical = false
        curTopLeft.x = 10 + cornerSize.width + coordBase.minX
        curBottomRight.x = 10 + cornerSize.width + coordBase.minX
        
        for loopIndex in (2..<11).reversed() {
            index = loopIndex
            incrementBottomRight(horizontalSize)
            addMidpoint()
            resetTopLeft()
        }
        return cellCenters
    }
    
    var body: some View {
        let cornerSize: CGSize = calculateCornerCellSize(geometry)
        let verticalSize: CGSize = calculateNonCornerCellSize(geometry, horizontal: false)
        let horizontalSize: CGSize = calculateNonCornerCellSize(geometry, horizontal: true)
        
        VStack(spacing: 0) {
            /// Top Row
            HStack(spacing: 0) {
                CellView(index: 21 , cellSize: cornerSize, vertical: false)
                ForEach(Array(22..<31).reversed(), id: \.self) { index in
                    CellView(index: index , cellSize: horizontalSize, vertical: false)
                }
                CellView(index: 31 , cellSize: cornerSize, vertical: false)
            }
            .rotated(.degrees(180))

            
            HStack {
                /// left column
                HStack(spacing: 0) {
                    
                    ForEach(Array((12..<21).reversed()), id: \.self) { index in
                        CellView(index: index , cellSize: verticalSize, vertical: true)
                    }
                }
                .rotated(.degrees(90))
                
                /// Center Opening
                Spacer()
                    .frame(width: verticalSize.height * 9, height: verticalSize.height * 9)
                    .background(Color("Board"))
                    .overlay(SkylineView(scaleFactor: 1))
                /// Right column
                
                HStack(spacing: 0) {
                    
                    ForEach(Array(32..<41).reversed(), id: \.self) { index in
                        CellView(index: index , cellSize: verticalSize, vertical: true)
                    }
                }
                .rotated(.degrees(-90))

            } // Add trailing padding to the right VStack

            /// Bottom Row
            HStack(spacing: 0) {
                CellView(index: 11 , cellSize: cornerSize, vertical: false)
                ForEach(Array((2..<11).reversed()), id: \.self) { index in
                    CellView(index: index , cellSize: horizontalSize, vertical: false)
                }
                CellView(index: 1 , cellSize: cornerSize, vertical: false)
            }
        }
        .drawingGroup() // Improve performance when using many rectangles
        .onAppear(){
            cellCenters = generateCenters()
        }
        .cornerRadius(5)


        .border(Color.black.opacity(0.5), width: 2)
        .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 2) // Add shadow to the ZStack

        .padding(.horizontal, 10)

    }
    
    func calculateNonCornerCellSize(_ geometry: GeometryProxy, horizontal: Bool) -> CGSize {
        let padding = 10
        let availableWidth = geometry.size.width
        let availableHeight = geometry.size.height
        let minSide = min(availableWidth, availableHeight) - CGFloat(2 * padding)
        let middleSpaces = boardSize - 2
        let unitsOfMiddleSpaces = middleSpaces * 0.7
        let portionTakenByMiddleSpaces = unitsOfMiddleSpaces / (unitsOfMiddleSpaces + 2)
        let side = minSide * portionTakenByMiddleSpaces / middleSpaces
        if horizontal {
            let cellWidth = side
            let cellHeight = side / horizontalSpaceRatio
            return CGSize(width: cellWidth, height: cellHeight)
        } else {
            let cellHeight = side
            let cellWidth = side / verticalSpaceRatio
            return CGSize(width: cellWidth, height: cellHeight)
        }
    }
    
    func calculateCornerCellSize(_ geometry: GeometryProxy) -> CGSize{
        let padding = 10
        let availableWidth = geometry.size.width
        let availableHeight = geometry.size.height
        let minSide = min(availableWidth, availableHeight) - CGFloat(2 * padding)
        let middleSpaces = boardSize - 2
        let unitsOfMiddleSpaces = middleSpaces * 0.7
        let portionTakenByMiddleSpaces = unitsOfMiddleSpaces / (unitsOfMiddleSpaces + 2)
        let width = minSide * (1 - portionTakenByMiddleSpaces) / 2
        let height = width
        return CGSize(width: width, height: height)
    }
}



let monopolyColors: [Int: Color] = [
    1: .red,
    2: .brown,
    3: .white,
    4: .brown,
    5: .white,
    6: .black,
    7: .cyan,
    8: .white,
    9: .cyan,
    10: .cyan,
    11: .orange,
    12: .pink,
    13: .yellow,
    14: .pink,
    15: .pink,
    16: .black,
    17: .orange,
    18: .white,
    19: .orange,
    20: .orange,
    21: .red,
    22: .red,
    23: .white,
    24: .red,
    25: .red,
    26: .black,
    27: .yellow,
    28: .yellow,
    29: .yellow,
    30: .yellow,
    31: .blue,
    32: .green,
    33: .green,
    34: .white,
    35: .green,
    36: .black,
    37: .white,
    38: .blue,
    39: .white,
    40: .blue
]


