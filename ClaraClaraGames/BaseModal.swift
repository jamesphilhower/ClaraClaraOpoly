import SwiftUI

import SwiftUI

struct BaseModalButtonView: View {
    var isEnabled: Bool
    var checkEnabled: () -> Bool
    var action: () -> Void
    var text: String
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text(text)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(isEnabled ? Color.blue : Color.gray)
                .cornerRadius(10)
        }
        .disabled(!checkEnabled())
    }
}


struct BaseModalView<Content: View>: View {    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack {
            content
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding()
        }
    }
}
