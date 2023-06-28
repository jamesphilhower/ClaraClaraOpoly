import SwiftUI

// TODO this latest move is definitely a Todo
class PlayersData: ObservableObject {
    @Published var players: [Player] = []
    @Published var roll: Int = 0
    @Published var latestMove: Move = Move(originalIndex: 0, newIndex: 0)
    @Published var currentPlayerIndex: Int = -1
}

struct Move {
    let originalIndex: Int
    let newIndex: Int
}
