import SwiftUI
struct PropertyCardView: View {
    let property: Property
    
    var body: some View {
        VStack(spacing: 4) {
            
            Image(systemName: property.iconName)
                .font(.system(size: 22))
                .foregroundColor(property.color)
                .frame(height: 40)
                .padding(.vertical, 8)
            
            Text("$\(property.purchasePrice)")
                .font(.system(size: 10))
                .foregroundColor(.black)
            
            Spacer()
        }
        .padding(8)
        .frame(width: 50, height: 75) // Set a fixed frame size
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .strokeBorder(property.color, lineWidth: 1)
                        .padding(2)
                )
        )
        .shadow(radius: 3)
    }
}
