import SwiftUI

struct GameBoardView: View {
    var selectedGameBoard: String
    @EnvironmentObject private var playersData: PlayersData
    @State private var regenerateBoard = false
    @State  var cellCenters: [Int: CGPoint] = [:] // Dictionary to store the centers of the cell views
    @State private var originalIndex: Int = 0
    @State private var newIndex: Int = 0
    
    
    func getCirclePosition() -> CGPoint {
        guard let center = cellCenters[originalIndex] else {
            return .zero
        }
        return center
    }
    
    func moveCircle(from originalIndex: Int, to newIndex: Int) {
        guard let originalCenter = cellCenters[originalIndex], let newCenter = cellCenters[newIndex] else {
            return
        }
        withAnimation {
            print("Moving circle from \(originalCenter) to \(newCenter)")
            
            // Update the originalIndex and newIndex
            self.originalIndex = originalIndex
            self.newIndex = newIndex
        }
    }
    
    
    var body: some View {
        VStack {
            Text("Game Board Placeholder")
                .font(.title)
                .padding()
            
            GeometryReader { geometry in
                if selectedGameBoard == "Traditional" {
                    TraditionalGameBoardView(geometry: geometry, cellCenters: $cellCenters).overlay(
                        ForEach(playersData.players, id: \.self){ player in
                            
                            let index = player.location
                            let x = cellCenters[index]!.x
                            let y = cellCenters[index]!.y

                            Circle().frame(width: 14, height: 14).position(x: x, y: y).foregroundColor(.blue).animation(.linear(duration: 0.3))
                    }
                    )
                } else if selectedGameBoard == "InfinityGameBoardView" {
                    InfinityGameBoardView()
                } else if selectedGameBoard == "ShootsAndLadders" {
                    ShootsAndLaddersGameBoardView()
                }
            } .onChange(of: playersData.roll, perform: { _ in
                // Trigger the regeneration of the board when the player's position changes
            }).onReceive(playersData.objectWillChange) { _ in
                regenerateBoard.toggle()
            }
        }
    }
    private func dumpCellCenters() {
        let sortedCellCenters = cellCenters.sorted(by: { $0.key < $1.key })
        for (index, center) in sortedCellCenters {
            print("Cell \(index): \(center)")
        }
    }
}

var curTopLeft: CGPoint = CGPoint(x: 0, y: 0)
var curBottomRight: CGPoint = CGPoint(x: 0, y: 0)


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
        
            print("Vertical", verticalSize)
            print("Hori", horizontalSize)
            print("corner", cornerSize)

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
        let coordBase = geometry.frame(in: .global)
//        var curTopLeft = CGPoint(x: coordBase.minX, y: coordBase.minY)
//        var curBottomRight = CGPoint(x: coordBase.maxX, y: coordBase.maxY)
//
        
        let cornerSize: CGSize = calculateCornerCellSize(geometry)
        let verticalSize: CGSize = calculateNonCornerCellSize(geometry, horizontal: false)
        let horizontalSize: CGSize = calculateNonCornerCellSize(geometry, horizontal: true)
        var curTopLeft = CGPoint(x: coordBase.minX + 10, y: coordBase.minY + 10)
        var curBottomRight = CGPoint(x: cornerSize.width + 10, y: cornerSize.height + 10)
        
        VStack(spacing: 0) {
            /// Top Row
            HStack(spacing: 0) {
                CellView(index: 21 , cellCenters: $cellCenters,cellSize: cornerSize, vertical: false)
                ForEach(22..<31) { index in
                    CellView(index: index , cellCenters: $cellCenters,cellSize: horizontalSize, vertical: false)
                }
                CellView(index: 31 , cellCenters: $cellCenters,cellSize: cornerSize, vertical: false)
            }
            
            
            
            HStack {
                /// left column
                VStack(spacing: 0) {
                    ForEach(Array((12..<21).reversed()), id: \.self) { index in
                        CellView(index: index , cellCenters: $cellCenters,cellSize: verticalSize, vertical: true)
                    }
                }
                .padding(.leading, 10)// Add leading padding to the left
                /// Center Opening
                Spacer()
                /// Right column
                VStack(spacing: 0) {
                    ForEach(Array(32..<41), id: \.self) { index in
                        CellView(index: index , cellCenters: $cellCenters,cellSize: verticalSize, vertical: true)
                    }
                }.padding(.trailing, 10) // Add trailing padding to the right VStack
            }
            /// Bottom Row
            HStack(spacing: 0) {
                CellView(index: 11 , cellCenters: $cellCenters,cellSize: cornerSize, vertical: false)
                ForEach(Array((2..<11).reversed()), id: \.self) { index in
                    CellView(index: index , cellCenters: $cellCenters,cellSize: horizontalSize, vertical: false)
                }
                CellView(index: 1 , cellCenters: $cellCenters,cellSize: cornerSize, vertical: false)
            }
        }.onAppear(){
            cellCenters = generateCenters()
        }
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


struct CellView: View {
    @EnvironmentObject var playersData: PlayersData
    
    let index: Int
    @Binding var cellCenters:  [Int: CGPoint]
    let cellSize: CGSize
    let vertical: Bool
    
    var body: some View {

        Rectangle()
            .fill(Color.gray)
            .frame(width: cellSize.width, height: cellSize.height)
            .overlay(
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        VStack(spacing: 0) {
                            let playersOnLocation = playersData.players.filter {$0.location == index }
                            ForEach(playersOnLocation.indices, id: \.self) { playerIndex in
                                let  width = calculatePlayerSize(cellSize: max(cellSize.width, cellSize.height))
                                let height = calculatePlayerSize(cellSize: max(cellSize.width, cellSize.height))
                                let offset = calculatePlayerOffset(
                                    playerIndex,
                                    totalPlayers: playersOnLocation.count,
                                    playerSize: width, cellWidth: cellSize.width, cellHeight : cellSize.height)
                                
                                
                                Circle()
                                    .fill(playersData.players[playerIndex].color)
                                    .frame(width: width, height: height)
                                    .offset(x: offset.width, y: offset.height)
                                
                            }
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                }
            )
            .overlay(
                Text("\(index)")
                    .foregroundColor(.white)
                    .font(.caption)
            )
            .onAppear {
                // assume starting point is correct
                // store prev and then use it for the midpoint
//                print("before botRight \(curBottomRight) topLeft \(curTopLeft)")
//                if vertical {
//                    curBottomRight.y += cellSize.height
//                } else {
//                    curBottomRight.x += cellSize.width
//                }
//
//
//                print("midpoint \(index): \((curTopLeft.x + curBottomRight.x) / 2), \((curTopLeft.y + curBottomRight.y) / 2)")
//                self.cellCenters[index] = CGPoint(x: ((curTopLeft.x + curBottomRight.x) / 2).rounded(.towardZero) , y: ((curTopLeft.y + curBottomRight.y) / 2).rounded(.towardZero))
//                if vertical {
//                    curTopLeft.y = curBottomRight.y
//                } else {
//                    curTopLeft.x = curBottomRight.x
//
//                }
                
                
            }
    }
    
    // Calculate the player size based on the number of players
    private func calculatePlayerSize(cellSize: CGFloat) -> CGFloat {
        let playerSize = cellSize * 0.25 * 0.7
        return playerSize
    }
    
    private func calculatePlayerOffset(_ playerIndex: Int, totalPlayers: Int, playerSize: CGFloat, cellWidth: CGFloat, cellHeight: CGFloat) -> CGSize {
        let rowCapacity = 2 // Maximum number of players in a row
        var xOffset:CGFloat = 0
        var yOffset:CGFloat = 0
        if totalPlayers == 1{
            return CGSize(width: xOffset, height: yOffset)
            
        }
        
        let rowIndex = playerIndex / rowCapacity
        let colIndex = playerIndex % rowCapacity
        
        if totalPlayers == 2 {
            let spacing = 0.2 * ( cellHeight == cellWidth ? cellHeight * 0.7 : min(cellHeight, cellWidth) )
            if colIndex == 1 {
                // undo VStack
                yOffset -= playerSize
                // shift right of center
                xOffset += spacing
            } else {
                // shift left of center
                xOffset -= spacing
            }
            if rowIndex == 0 {
                // shift vertically down
                yOffset += spacing
            }
        } else if totalPlayers == 3 {
            let spacing = 0.2 * ( cellHeight == cellWidth ? cellHeight * 0.7 : min(cellHeight, cellWidth) )
            if colIndex == 1 {
                // undo VStack
                yOffset -= playerSize
                // shift right of center
                xOffset += spacing
            } else {
                // shift left of center
                xOffset -= spacing
            }
        }
        
        else if totalPlayers == 4 {
            let verticalSpacing = 0.2 * ( cellHeight == cellWidth ? cellHeight * 0.7 : min(cellHeight, cellWidth) )
            let horizontalSpacing = 0.2 * ( cellHeight == cellWidth ? cellHeight * 0.7 : min(cellHeight, cellWidth) )
            if colIndex == 1 {
                // undo VStack
                yOffset -= playerSize
                // shift right of center
                xOffset += horizontalSpacing
            } else {
                // shift left of center
                xOffset -= horizontalSpacing
            }
            yOffset += playerSize / 2
            
        }
        
        
        return CGSize(width: xOffset, height: yOffset)
    }
    
}







struct InfinityGameBoardView: View {
    @State private var overlapDistance: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            let radius = min(geometry.size.width, geometry.size.height) / 2
            let overlap = calculateVerticalDistance(radius: radius, angle: 60)
            let distance = (radius - overlap) * 2
            
            VStack(spacing: -distance) {
                InfinityView(radius: radius)
                    .rotationEffect(.degrees(0))
                
                InfinityView(radius: radius)
                    .rotationEffect(.degrees(180))
            }
            .frame(maxWidth: .infinity)
            .onAppear {
                overlapDistance = distance
            }
        }
    }
    
    func calculateVerticalDistance(radius: CGFloat, angle: CGFloat) -> CGFloat {
        let halfAngle = angle / 2.0
        let verticalDistance = radius * cos(halfAngle * .pi / 180.0)
        return verticalDistance
    }
}

struct InfinityView: View {
    let numberOfPieces = 20
    let radius: CGFloat
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<numberOfPieces) { index in
                    ZStack {
                        Pie(radius: radius, startAngle: angle(for: index), endAngle: angle(for: index+1))
                            .fill(color(for: index))
                        Text("\(index + 1)")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .bold))
                            .position(getTextPosition(index: index, in: geometry))
                    }
                }
            }
        }
    }
    
    private func angle(for index: Int) -> Angle {
        let anglePerPiece = 360.0 / Double(numberOfPieces)
        return Angle(degrees: Double(index) * anglePerPiece)
    }
    
    private func color(for index: Int) -> Color {
        let hue = Double(index) / Double(numberOfPieces)
        return Color(hue: hue, saturation: 1.0, brightness: 1.0)
    }
    
    private func getTextPosition(index: Int, in geometry: GeometryProxy) -> CGPoint {
        let anglePerPiece = 360.0 / Double(numberOfPieces)
        let midAngle = angle(for: index).degrees + (anglePerPiece / 2.0)
        let radius = min(geometry.size.width, geometry.size.height) / 2.0
        
        let x = cos(midAngle * .pi / 180.0) * (radius - 20) + geometry.size.width / 2.0
        let y = sin(midAngle * .pi / 180.0) * (radius - 20) + geometry.size.height / 2.0
        
        return CGPoint(x: x, y: y)
    }
}


struct Pie: Shape {
    let radius: CGFloat
    let startAngle: Angle
    let endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        //        let radius = min(rect.width, rect.height) / 2
        
        path.move(to: center)
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.addArc(center: center, radius: radius/2, startAngle: endAngle, endAngle: startAngle, clockwise: true)
        path.closeSubpath()
        
        return path
    }
}



struct ShootsAndLaddersGameBoardView: View {
    
    var body: some View {
        Text("Shoots and Ladders Game Board Placeholder")
    }
}
