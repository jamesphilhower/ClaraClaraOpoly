import SwiftUI

struct PlayerTokensView: View {
    @ObservedObject var playersData: PlayersData
    @Binding var cellCenters: [Int: CGPoint]
    @Binding var rotationAngle: Double
    var body: some View {
        if let player = playersData.players[safe: playersData.currentPlayerIndex]{
            let boardSpaceIndex = player.location
            let x = cellCenters[boardSpaceIndex]?.x ?? 0
            let y = cellCenters[boardSpaceIndex]?.y ?? 0
            
            let skiOptions = ["figure.skiing.crosscountry","figure.elliptical","figure.skiing.downhill"]
            
            let stretchOptions =
                ["figure.cooldown", "figure.flexibility", "figure.dance"]
            
            let danceOptions = [
                "figure.boxing", "figure.dance", "figure.strengthtraining"]
            
            withAnimation(.default) {
                Image(systemName: "figure.run")
                    .font(.system(size: 20))
                    .modifier(flipAndRotateModifier(for: boardSpaceIndex, rotationAngle: rotationAngle))
                    .background(Circle().frame(width: 20, height: 25).foregroundColor(.white).shadow(color: .white, radius: 5))
                    .position(x: x, y: y)
                    .foregroundColor(.blue)
            }
        }
    }
    }


func flipAndRotateModifier(for boardSpaceIndex: Int, rotationAngle: Double) -> some ViewModifier {
    var flip: Bool = false
    var rotation: Double = 0

print("moving moving moving", rotationAngle, boardSpaceIndex)
    // 0 all good
    // 90 verticals are off 180
    // 180 all good
    // 270 all off -90 hor 180 ver
        switch boardSpaceIndex {
        case 0...10: //hor
            flip = rotationAngle >= 180 ? false :  true
            rotation = rotationAngle == 0 || rotationAngle == 180 ? 0 : 0
        case 11...20: //ver
            flip = rotationAngle == 0 || rotationAngle == 270 ? false : true
            rotation = rotationAngle == 0 || rotationAngle == 180 ? 90 : 90
        case 21...30: //hor
            flip = rotationAngle <= 90 ? false :  true
            rotation = rotationAngle == 0 || rotationAngle == 180 ? -180 : 180
        case 31...40: //ver
            flip = rotationAngle == 180 || rotationAngle == 90 ? false : true
            rotation = rotationAngle == 0 || rotationAngle == 180 ? 270 : -90
        default:
            flip = false
            rotation = 0
        }
    
    return ViewModifierFlipAndRotate(scaleX: flip ? -1 : 1, rotationAngle: rotationAngle - rotation)
}

struct ViewModifierFlipAndRotate: ViewModifier {
    let scaleX: CGFloat
    let rotationAngle: Double
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(x: scaleX, y: 1)
            .rotated(.degrees(rotationAngle))
    }
}
