import SwiftUI

struct GameBoardView: View {
    var selectedGameBoard: String
    @EnvironmentObject private var playersData: PlayersData
    @State private var regenerateBoard = false
    @State var cellCenters: [Int: CGPoint] = [:] // Dictionary to store the centers of the cell views
    @State private var originalIndex: Int = 0
    @State private var newIndex: Int = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(playersData.players, id: \.self){ player in
                    switch player.id {
                    case 0:
                        // Bottom Left
                        BillsView(bills: calculateBills(for: player.money)).position(x: geometry.size.width / 2, y: geometry.size.width + 10)
                    case 1:
                        // Top Left Side
                        BillsView(bills: calculateBills(for:  player.money)).rotated(.degrees(90)).position(x: -10, y: geometry.size.height/2)
                    case 2:
                        // Bottom Right Side
                        BillsView(bills: calculateBills(for:  player.money)).rotated(.degrees(270)).position(x: geometry.size.width - 10, y: geometry.size.width / 2)
                    case 3:
                        // Top Right
                        BillsView(bills: calculateBills(for:  player.money)).rotated(.degrees(180)).position(x: geometry.size.width / 2, y: 20)
                    default:
                        BillsView(bills: calculateBills(for: 0))
                        
                    }
                }
                
                if selectedGameBoard == "Traditional" {
                    TraditionalGameBoardView(geometry: geometry, cellCenters: $cellCenters)
                        .overlay(
                            ForEach(playersData.players, id: \.self){ player in
                                
                                let index = player.location
                                let x = cellCenters[index]!.x
                                let y = cellCenters[index]!.y
                                
                                Circle().frame(width: 14, height: 14).position(x: x, y: y).foregroundColor(.blue).animation(.default)
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
}
