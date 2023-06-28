import SwiftUI

extension Player {
    
    
    func useGetOutOfJailFreeCard() {
        if getOutOfJailCards > 0 {
            getOutOfJailCards -= 1
            consecutiveTurnsInJail = 0
        }
        self.inJail = false
    }
    
    func payToGetOutOfJail() {
        payFee(50)
        self.inJail = false
    }
    
    
    func goToJail() {
        self.inJail = true
        self.location = 10
        DispatchQueue.main.async {
            self.playersData.roll += 1
        }
    }
    
    
}
