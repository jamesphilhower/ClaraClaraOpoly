import SwiftUI

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


struct InfinityGameBoard: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct InfinityGameBoard_Previews: PreviewProvider {
    static var previews: some View {
        InfinityGameBoard()
    }
}
