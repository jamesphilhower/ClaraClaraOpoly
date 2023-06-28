import SwiftUI

struct MoneyUnderBoardView: View {
    let geometry: GeometryProxy
    let playersData: PlayersData
    var body: some View {
        let startX = geometry.frame(in: .global).minX
        let startY = geometry.frame(in: .global).minY
        let endX = geometry.frame(in: .global).maxX
        ForEach(playersData.players, id: \.self) { player in
            switch player.id {
            case 0:
                // Bottom Left
                BillsView(bills: calculateBills(for: player.money))
                    .position(x: startX + geometry.size.width / 2, y: startY + geometry.size.width + 10)
            case 1:
                // Top Left Side
                BillsView(bills: calculateBills(for: player.money))
                    .rotated(.degrees(90))
                    .position(x: startX - 10, y: startY + (geometry.size.width / 2))
            case 2:
                // Bottom Right Side
                BillsView(bills: calculateBills(for: player.money))
                    .rotated(.degrees(270))
                    .position(x: startX + endX - 10, y: startY + geometry.size.width / 2)
            case 3:
                // Top Right
                BillsView(bills: calculateBills(for: player.money))
                    .rotated(.degrees(180))
                    .position(x: startX + geometry.size.width / 2, y: startY + 20)
            default:
                BillsView(bills: calculateBills(for: 0))
            }
        }
    }
}
