import SwiftUI

struct GameBoardView: View {
    var selectedGameBoard: String
    @EnvironmentObject private var playersData: PlayersData
    @State private var regenerateBoard = false
    @State var cellCenters: [Int: CGPoint] = [:]
    @State private var originalIndex: Int = 0
    @State private var newIndex: Int = 0
    @State private var rotationAngle: Double = 0
    @State private var hasShifted: Bool = false
    var body: some View {
        GeometryReader { geometry in
            VStack {
                if playersData.currentPlayerIndex != -1{
                    Text("It's \(playersData.players[safe: playersData.currentPlayerIndex]?.name ?? "")'s Turn").font(.title).foregroundColor(.black)
                        .background(RoundedRectangle(cornerRadius: 15).frame(width: UIScreen.main.bounds.width * 0.8, height: 30).foregroundColor(.white.opacity(0.75)))
                } else {
                    Text("Welcome!").font(.title).foregroundColor(.black).background (RoundedRectangle(cornerRadius: 15).frame(width: UIScreen.main.bounds.width * 0.8, height: 30).foregroundColor(.white.opacity(0.75)))
                }
               
                if selectedGameBoard == "Traditional" {
                    TraditionalGameBoardView(geometry: geometry, cellCenters: $cellCenters, rotationAngle: $rotationAngle)
                    // 30 is used to offset the money so you can see the whole bill
                        .position(x: geometry.size.width / 2 , y: geometry.size.width / 2 + 30)
                        .onChange(of: playersData.currentPlayerIndex){ val in
                            print("From the gameboard changing player", val, playersData.currentPlayerIndex)
                            if playersData.currentPlayerIndex == -1 {
                                return
                            }
                            else if !hasShifted {
                                rotationAngle = Double(val * 90)
                                self.hasShifted = true
                            } else {
                                print("should be rotation")
                                withAnimation {
                                    rotationAngle += 90
                                }
                                switch playersData.players.count {
                                case 2:
                                    rotationAngle = Double(Int(rotationAngle) % 180)
                                case 3:
                                    rotationAngle = Double(Int(rotationAngle) % 270)
                                case 4:
                                    rotationAngle = Double(Int(rotationAngle) % 360)
                                default:
                                    print("wrong number of players")
                                }
                            }
                            
                        }
//                        .overlay(
//                            // 40 from 30 used in offset for money bills (this file, above) and 10 for padding (in TraditionalGameBoardView)
//                            PlayerTokensView(playersData: playersData, cellCenters: $cellCenters, rotationAngle: $rotationAngle).offset(y: 40)
//                        )
                        .overlay(DiceView().offset(y: -100))
                        .shadow(radius: 1)
                        .cornerRadius(3)
                } else if selectedGameBoard == "InfinityGameBoardView" {
                    InfinityGameBoardView()
                } else if selectedGameBoard == "ShootsAndLadders" {
                    ShootsAndLaddersGameBoardView()
                }
            }.drawingGroup()
        }}
}
