import SwiftUI

extension Player {
    
    func handleLandingOnSpace(roll: Int) async {
        let space = propertiesData.spaces[self.location]
        print("Landed on space: \(space.name)")
        
        switch space.group {
        case "NonProperty":
            if let nonProperty = space as? NonPropertySpace {
                print("Executing onLand for NonPropertySpace")
                await nonProperty.onLand(self)
            }
        case "utilities":
            if let property = space as? Utility {
                if let owner = property.owner {
                    print("Utility property owned by another player. Paying rent.")
                    payPlayer(roll * calculateRent(for: property), player: owner)
                } else {
                    print("Utility property unowned. Offer player to purchase for \(property.purchasePrice)")
                }
            }
        case "rr":
            if let property = space as? Railroad {
                if let owner = property.owner {
                    print("Railroad property owned by another player. Paying rent.")
                    payPlayer(calculateRent(for: property), player: owner)
                } else {
                    print("Railroad property unowned. Offer player to purchase for \(property.purchasePrice)")
                }
            }
        default:
            if let property = space as? Property {
                if let owner = property.owner {
                    print("Property owned by another player. Paying rent.")
                    payPlayer(calculateRent(for: property), player: owner)
                } else {
                    print("Property unowned. Offer player to purchase for \(property.purchasePrice)")
                }
            }
        }
    }

    
    func move(spaces: Int) async {
        // Todo needs to be done in a smarter way so that it's not always 2 seconds but based on spaces
        // Todo merge this function with movebackwards
        if self.inJail{
            print("player in jail, not moving")
            return
        }
        var totalDuration: Double = 9
//
//        switch spaces {
//        case 0...4:
//            totalDuration = 1
//        case 5...10:
//            totalDuration = 1.5
//        case 11...20:
//            totalDuration = 2
//        case 20...30:
//            totalDuration = 2.5
//        case 30...40:
//            totalDuration = 3
//        default:
//            totalDuration = 1
//
//        }
        
        let sleepInterval = totalDuration / Double(spaces)
        
        for _ in 0..<spaces {
            if self.location == 39 {
                self.location = 0
            } else {
                self.location += 1
            }
            DispatchQueue.main.async {
                
                self.playersData.roll += 1
                
            }
            do {
                try await Task.sleep(nanoseconds: UInt64(sleepInterval * 1_000_000_000))
            } catch {
                print("Error occurred during sleep")
            }
        }
    }
    
    
    func moveBackwards(_ spaces: Int) async {
        // Todo merge this function with move
        let totalDuration: Double = 2.0
        let sleepInterval = totalDuration / Double(spaces)
        for _ in 0..<spaces {
            if self.location == 0 {
                self.location = 39
            } else {
                self.location -= 1
            }
            DispatchQueue.main.async {
                self.playersData.roll += 1
            }
            do {
                try await Task.sleep(nanoseconds: UInt64(sleepInterval * 1_000_000_000))  // Convert sleep interval to nanoseconds
            } catch {
                // Handle sleep error
                print("Error occurred during sleep")
            }
        }
    }
    
    
    func movePlayerToProperty(propertyName: String) async {
        let endLocation = propertiesData.spaces.firstIndex(where: { $0.name == propertyName })
        if (endLocation == nil) {
            print("Unable to find property to move to")
            return
        }
        let spacesToMove = endLocation! > self.location ? endLocation! - self.location : 40 - (self.location - endLocation!)
        await move(spaces: spacesToMove)
        print("After the moves", self.location)
    }

    func moveToNearest(propertyGroup: String) async {
       
        let currentIndex = self.location
        var counter = 1
        var endLocation: Int?

        while endLocation == nil {
            let index = (currentIndex + counter) % 40
            if propertiesData.spaces[index].group == propertyGroup {
                endLocation = index
            } else {
                counter += 1
            }
        }

        await move(spaces: counter)
        
        if let currentProp = propertiesData.spaces[self.location] as? Property {
            if currentProp.owner == nil {
                //Todo
                print("Property is unowned")
            }
            else if currentProp.owner != self {
                print("Property is owned, paying other player")
                payPlayer(propertyGroup == "rr" ? 2 * calculateRent(for: currentProp) : 10 * abs(playersData.latestMove.newIndex - playersData.latestMove.newIndex), player: currentProp.owner!)
            }
            else {
                print("Property is owned, no further action")
            }
        }
    }
}
