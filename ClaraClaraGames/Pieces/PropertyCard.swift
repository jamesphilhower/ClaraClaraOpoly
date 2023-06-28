import SwiftUI
struct PropertyCardView: View {
    let property: Property
    
    var body: some View {
        VStack(spacing: 4) {
            Text(property.name)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.black)
                .padding(.top, 8)
            
            Image(systemName: property.iconName)
                .font(.system(size: 32))
                .foregroundColor(property.color)
                .frame(height: 40)
                .padding(.vertical, 8)
            
            Text("$\(property.purchasePrice)")
                .font(.system(size: 10))
                .foregroundColor(.black)
            
            Spacer()
        }
        .padding(8)
        .frame(width: 70, height: 100) // Set a fixed frame size
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(property.color, lineWidth: 1)
                        .padding(2)
                )
        )
        .shadow(radius: 3)
    }
}
