import SwiftUI

struct CellView: View {
    @EnvironmentObject var propertiesData: PropertiesData
    
    @ObservedObject var property: BoardSpace
    var cellSize: CGSize
    @Binding var rotationAngle: Double
    var index: Int
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color("Board"))
                .frame(width:  min( cellSize.width, cellSize.height), height:  max( cellSize.width, cellSize.height))
            
            if let property = property as? Property {
                
                if cellSize.width != cellSize.height {
                    Rectangle().fill(property.color).frame(width: min( cellSize.width, cellSize.height), height: 15)
                        .overlay(
                            Group {
                                if let buildableProperty = property as? BuildableProperty {
                                    HStack(spacing: -3){
                                        if buildableProperty.hasHotel {
                                            Image(systemName: "house.lodge.fill").font(.system(size: 12)).foregroundColor(.white)
                                        } else {
                                            ForEach(0..<buildableProperty.numberHouses, id: \.self) { _ in
                                                Image(systemName: "house.fill").font(.system(size: 8)).foregroundColor(.white)}
                                        }
                                        
                                    }
                                }
                            }
                        )
                        .offset(y: ( max( cellSize.width, cellSize.height) - 15) / -2)

                }
            }
            
            if let space = property as? Property {
                Image(systemName: space.iconName)
                    .frame(width: min(cellSize.width, cellSize.height), height: max(cellSize.width, cellSize.height))
                    .foregroundColor(space.color)
                    .offset(y: cellSize.height * 0.15)
            } else if let space = property as? NonPropertySpace {
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
                        PlayersOnLocation(index: index, cellSize: cellSize, rotationAngle: $rotationAngle)
                    }
                    .frame(width:  cellSize.width, height:  cellSize.height)
                }
            }
        )
        .border(Color.gray.opacity(0.5), width: 0.4)

    }
    
    
    private func imageRotationAngle(for index: Int)-> Angle {
        switch index {
            
        case 10:
            return .degrees(45)
        case 20:
            return .degrees(-45)
        case 30:
            return .degrees(45)
        case 0:
            return .degrees(0)
        default:
            return .degrees(0)
        }
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
                return CGSize(width: xOffset, height: 7)
                
            }
            let rowIndex = playerIndex / rowCapacity
            let colIndex = playerIndex % rowCapacity
            
            if totalPlayers == 2 {
                let spacing = 0.2 * ( cellHeight == cellWidth ? cellHeight * 0.7 : min(cellHeight, cellWidth) )
                if colIndex == 1 {
                    xOffset += spacing
                } else {
                    // shift left of center
                    xOffset -= spacing
                }
            } else if totalPlayers == 3 || totalPlayers == 4 {
                let spacing = 0.2 * ( cellHeight == cellWidth ? cellHeight * 0.7 : min(cellHeight, cellWidth) )
                if colIndex == 1 {
                    // shift right of center
                    xOffset += spacing
                } else {
                    // shift left of center
                    xOffset -= spacing
                }
                if rowIndex == 0 {
                    // shift vertically down
                    yOffset += spacing
                } else {
                    yOffset -= spacing
                }
            }
           
            return CGSize(width: xOffset, height: yOffset)
        }
        let index: Int
        
        
        let cellSize: CGSize
        @Binding var rotationAngle: Double

        
        var body: some View {
            ZStack {
                let playersOnLocation = playersData.players.filter {$0.location == index }
                ForEach(playersOnLocation.indices, id: \.self) { playerIndex in
                    let  width = calculatePlayerSize(cellSize: max(cellSize.width, cellSize.height))

                    let offset = calculatePlayerOffset(
                        playerIndex,
                        totalPlayers: playersOnLocation.count,
                        playerSize: width, cellWidth: cellSize.width, cellHeight : cellSize.height)
                    
                    let skiOptions = ["figure.skiing.crosscountry","figure.elliptical","figure.skiing.downhill"]
                    
                    let stretchOptions =
                    ["figure.cooldown", "figure.flexibility", "figure.dance"]
                    
                    let danceOptions = [
                        "figure.boxing", "figure.dance", "figure.strengthtraining"]
                    
                    Image(systemName: "figure.run")
                        .modifier(flipAndRotateModifier(for: index, rotationAngle: rotationAngle))
                        .foregroundColor(playersData.players[playersOnLocation[playerIndex].id].color)
                        .background(
                            Circle()
                                .fill(Color.white)
                                .frame(width: 17)
                                .overlay(
                                    Circle()
                                        .stroke(playersData.players[playersOnLocation[playerIndex].id].color, lineWidth: 2)
                                )
                        )

                        .font(.system(size: 16))
                        .offset(x: offset.width, y: offset.height)
                    
                }
            }
        }
    }
    
    
}

