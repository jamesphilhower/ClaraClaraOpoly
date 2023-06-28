import SwiftUI


class BoardSpace: ObservableObject {
    let name: String
    let iconName: String
    let color: Color
    let group: String
    
    init(name: String, iconName: String, color: Color, group: String = "NonProperty")
    {
        self.name = name
        self.iconName = iconName
        self.color = color
        self.group = group
    }
}
