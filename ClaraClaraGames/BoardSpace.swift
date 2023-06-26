import SwiftUI


let monopolyIcons: [Int: String] = [
    1: "arrow",
    2: "bicycle",
    3: "scooter",
    4: "building.2.fill",        // Brown
    5: "square.fill",            // White
    6: "building.fill",          // Black
    7: "bicycle",                // Cyan
    8: "questionmark.circle.fill",// White
    9: "bicycle",                // Cyan
    10: "bicycle",               // Cyan
    11: "flame.fill",            // Orange
    12: "house.fill",            // Pink
    13: "train.fill",            // Yellow
    14: "house.fill",            // Pink
    15: "house.fill",            // Pink
    16: "building.fill",         // Black
    17: "square.fill",           // Orange
    18: "questionmark.circle.fill", // White
    19: "building.2.fill",       // Orange
    20: "building.2.fill",       // Orange
    21: "building.2.fill",       // Red
    22: "building.2.fill",       // Red
    23: "square.fill",           // White
    24: "building.2.fill",       // Red
    25: "building.2.fill",       // Red
    26: "building.fill",         // Black
    27: "bolt.fill",             // Yellow
    28: "bolt.fill",             // Yellow
    29: "bolt.fill",            // Yellow
    30: "bolt.fill",             // Yellow
    31: "building.2.fill",       // Blue
    32: "building.fill",         // Green
    33: "building.fill",         // Green
    34: "questionmark.circle.fill", // White
    35: "train.fill",            // Green
    36: "building.fill",         // Black
    37: "square.fill",           // White
    38: "building.2.fill",       // Blue
    39: "square.fill",           // White
    40: "building.2.fill"        // Blue
]

func imageRotationAngle(for index: Int)-> Angle {
    switch index {
        
    case 11:
        return .degrees(45)
    case 21:
        return .degrees(45)
    case 31:
        return .degrees(-45)
    case 1:
        return .degrees(-135)
    default:
        return .degrees(0)
    }
}


struct CellView: View {
    let index: Int
    var cellSize: CGSize
    let vertical: Bool
    
    
    
    
    var body: some View {
        let icon = monopolyIcons[index]!
        ZStack{
            Rectangle()
                .fill(Color("Board"))
                .frame(width:  min( cellSize.width, cellSize.height), height:  max( cellSize.width, cellSize.height))
            if ![11, 21, 31, 1].contains(index) {
                Rectangle().fill(monopolyColors[index]!).frame(width: min( cellSize.width, cellSize.height), height: 15)
                    .offset(y: ( max( cellSize.width, cellSize.height) - 15) / -2)
            }
            
            
            
            Image(systemName: icon)
                .frame(width:  min( cellSize.width, cellSize.height), height:  max( cellSize.width, cellSize.height))
                .foregroundColor(.white)
                .offset(
                    y: cellSize.height * 0.15
                ).rotationEffect(imageRotationAngle(for: index))
        }
                .overlay(
                    GeometryReader { geometry in
                        VStack(spacing: 0) {
                            VStack(spacing: 0) {
                                PlayersOnLocation(index: index, cellSize: cellSize)
                            }
                            .frame(width:  cellSize.width, height:  cellSize.height)
                        }
                    }
                )
        
                .border(Color.gray.opacity(0.5), width: 0.4)

        
    }
    
    
    
    struct PlayersOnLocation: View {
        @EnvironmentObject var playersData: PlayersData
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
        let index: Int
        
        let cellSize: CGSize
        
        var body: some View {
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
    }
    
    
}

