import SwiftUI

class PropertiesData: ObservableObject {
    @Published var properties: [Property] = []
}
