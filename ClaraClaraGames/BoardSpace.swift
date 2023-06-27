import SwiftUI

func imageRotationAngle(for index: Int)-> Angle {
    switch index {
        
    case 10:
        return .degrees(45)
    case 20:
        return .degrees(45)
    case 30:
        return .degrees(-45)
    case 0:
        return .degrees(0)
    default:
        return .degrees(0)
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

struct CellView: View {
    @EnvironmentObject var propertiesData: PropertiesData
    
    let index: Int
    var cellSize: CGSize
    let vertical: Bool
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color("Board"))
                .frame(width:  min( cellSize.width, cellSize.height), height:  max( cellSize.width, cellSize.height))
            
            if let property = propertiesData.spaces[safe: index] as? Property {
                
                if ![10, 20, 30, 0].contains(index) {
                    Rectangle().fill(property.color).frame(width: min( cellSize.width, cellSize.height), height: 15)
                        .offset(y: ( max( cellSize.width, cellSize.height) - 15) / -2)
                }
            }
            
            if let space = propertiesData.spaces[safe: index] as? Property {
                Image(systemName: space.iconName)
                    .frame(width: min(cellSize.width, cellSize.height), height: max(cellSize.width, cellSize.height))
                    .foregroundColor(space.color)
                    .offset(y: cellSize.height * 0.15)
            } else if let space = propertiesData.spaces[safe: index] as? NonPropertySpace {
                let width = cellSize.width == cellSize.height ? cellSize.width : min(cellSize.width, cellSize.height)
                Image(systemName: space.iconName)
                    .frame(width: width, height: max(cellSize.width, cellSize.height))
                    .foregroundColor(space.color)
                    .rotationEffect(imageRotationAngle(for: index))
            }
            
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
    
    
    // todo will probably deprecate this... shouldn't have spent forever on it
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

