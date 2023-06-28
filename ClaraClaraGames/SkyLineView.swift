import SwiftUI

struct GameNameView: View {
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Text("ClaraClaraOpoly").font(.custom("AmericanTypewriter", size: 40)).foregroundColor(.red).rotated(.degrees(45))
                    .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)

            }
            .drawingGroup()
        }
    }
}

struct GameNameView_Previews: PreviewProvider {
    static var previews: some View {
        GameNameView()
    }
}
