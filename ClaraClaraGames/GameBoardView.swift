import SwiftUI

struct GameBoardView: View {
    var selectedGameBoard: String
    
    var body: some View {
        VStack {
            Text("Game Board Placeholder")
                .font(.title)
                .padding()
            
            if selectedGameBoard == "Traditional" {
                TraditionalGameBoardView()
            } else if selectedGameBoard == "InfinityGameBoardView" {
                InfinityGameBoardView()
            } else if selectedGameBoard == "ShootsAndLadders" {
                ShootsAndLaddersGameBoardView()
            }
        }
    }
}

struct TraditionalGameBoardView: View {
    
    let boardSize: CGFloat = 11 // Total number of cells on the board
    let horizontalSpaceRatio: CGFloat = 0.7 // Ratio of width for horizontal spaces
    let verticalSpaceRatio: CGFloat = 0.7 // Ratio of height for vertical spaces
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Top Row
                HStack(spacing: 0) {
                    CellView(index: 21, cellSize: calculateCornerCellSize(geometry))
                    ForEach(22..<31) { index in
                        CellView(index: index, cellSize: calculateNonCornerCellSize(geometry, horizontal: true))
                    }
                    CellView(index: 31, cellSize: calculateCornerCellSize(geometry))
                    
                }
                
                // Vertical Rows
                HStack {
                    VStack(spacing: 0) {
                        ForEach(Array((12..<21).reversed()), id: \.self) { index in
                            CellView(index: index, cellSize: calculateNonCornerCellSize(geometry, horizontal: false))
                        }
                    }.padding(.leading, 10) // Add leading padding to the left VStack
                    
                    Spacer()
                    
                    VStack(spacing: 0) {
                        ForEach(Array(32..<41), id: \.self) { index in
                            CellView(index: index, cellSize: calculateNonCornerCellSize(geometry, horizontal: false))
                        }
                    }.padding(.trailing, 10) // Add trailing padding to the right VStack
                    
                }
                
                // Bottom Row
                HStack(spacing: 0) {
                    CellView(index: 11, cellSize: calculateCornerCellSize(geometry))
                    
                    ForEach(Array((2..<11).reversed()), id: \.self) { index in
                        CellView(index: index, cellSize: calculateNonCornerCellSize(geometry, horizontal: true))
                    }
                    CellView(index: 1, cellSize: calculateCornerCellSize(geometry))
                    
                }
            }
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
    
    struct CellCorner: View {
        let index: Int
        let cellSize: CGSize
        var body: some View {
            CellView(index: index, cellSize: cellSize)
        }
    }
    
    
    struct CellView: View {
        @EnvironmentObject var playersData: PlayersData
        
        let index: Int
        let cellSize: CGSize
        
        var body: some View {
            // Customize the appearance and content of each cell
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
                    
                    
                
//                if rowIndex == 0 {
//                    // shift vertically down
//                    yOffset -= verticalSpacing / 2
//                }
//                if rowIndex == 1 {
//                    // shift vertically down
//                    yOffset += verticalSpacing / 2
//                }
                
            }
            
//            let spacing = min(cellHeight, cellWidth) * 0.2
//            let rowIndex = playerIndex / rowCapacity
//            let colIndex = playerIndex % rowCapacity
//            var xOffset:CGFloat = 0
//            var yOffset:CGFloat = 0
//            if colIndex == 1 {
//                // undo VStack
//                yOffset -= playerSize
//                // shift right of center
//                xOffset += spacing
//            } else {
//                // shift left of center
//                xOffset -= spacing
//            }
//            if rowIndex == 0 {
//                // shift vertically down
//                yOffset += spacing
//            }


            
            return CGSize(width: xOffset, height: yOffset)
        }

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
