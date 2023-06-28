import SwiftUI

class NonPropertySpace: BoardSpace {
    let onLand: (Player)async -> Void
    
    init(
        name: String,
        iconName: String,
        onLand: @escaping (Player)async -> Void,
        color: Color
    ) {
        self.onLand = onLand
        super.init(
            name: name,
            iconName: iconName,
            color: color
        )
    }
}

class Start: NonPropertySpace {
    init() {
        super.init(
            name: "Start",
            iconName: "flag.checkered",
            onLand: { player in
                 player.collectFromBank(200)
            },
            color: .red
        )
    }
}

class CommunityChest: NonPropertySpace {
    init() {
        super.init(
            name: "Community Chest",
            iconName: "chart.xyaxis.line",
            onLand: { player in
                await player.drawCard("chest")
            },
            color: .mint
        )
    }
}

class Chance: NonPropertySpace {
    init() {
        super.init(
            name: "Travel Agent",
            iconName: "ticket",
            onLand: { player in
                await player.drawCard("chance")
            },
            color: .mint
        )
    }
}

private func doNothing(_ player: Player) {}
class Jail: NonPropertySpace {

    init() {
        super.init(
            name: "Jail",
            iconName: "tablecells",
            onLand: doNothing,
            color: .blue
        )
    }
}

class GoToJail: NonPropertySpace {
    init() {
        super.init(
            name: "Chance",
            iconName: "hand.raised",
            onLand: { player in
                player.goToJail()
            },
            color: .blue
        )
    }
}

class FreeParking: NonPropertySpace {
    init() {
        super.init(
            name: "Park",
            iconName: "tree",
            onLand: { player in
                player.handleFreeParking()
            },
            color: .green
        )
    }
}

class LuxuryTax: NonPropertySpace {
    init() {
        super.init(
            name: "Out of Policy Claim",
            iconName: "list.bullet.clipboard",
            onLand: { player in
                player.payFee(75)
            },
            color: .red
        )
    }
}

class IncomeTax: NonPropertySpace {
    init() {
        super.init(
            name: "Data Corruption",
            iconName: "externaldrive.badge.xmark",
            onLand: { player in
                player.handleIncomeTax()
            },
            color: .red
        )
    }
}
