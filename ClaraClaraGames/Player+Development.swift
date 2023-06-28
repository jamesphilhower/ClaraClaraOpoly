import SwiftUI

extension Player {
    func executeCards() async {
        
        // Execute chance cards
        for gameCard in self.cardData.chanceDrawPile {
            let cardName = gameCard.text
            
            print("--- Chance Card: \(cardName) ---")
            print("Before: $\(self.money) Loc: \(self.location)") // Print player status before executing the card
            
            do  { try
                await Task.sleep(nanoseconds: 2_000_000_000)
            }
            catch {
                print("Sleep Failed")
            }
            await gameCard.action(self) // Execute the card action
            
            print("After: $\(self.money) Loc: \(self.location)") // Print player status after executing the card
            print("")
            
            print("----------")
            do  { try
                await Task.sleep(nanoseconds: 2_000_000_000)
            }
            catch {
                print("Sleep Failed")
            }
            print("")
            
            DispatchQueue.main.async {
                self.cardData.chanceDrawIndex = ( self.cardData.chanceDrawIndex + 1 ) % 16
            }
            // waiting for the update to propogate?
            do {
                try await Task.sleep(nanoseconds: 500_000_000)
            }
            catch{
                print("Sleep broke")
            }
        }
        
        // Execute community chest cards
        for gameCard in self.cardData.communityChestDrawPile {
            let cardName = gameCard.text
            print("--- Community Chest Card: \(cardName) ---")
            print("Before: $\(self.money) Loc: \(self.location)") // Print player status before executing the card
            
            do {
                try await Task.sleep(nanoseconds: 2_000_000_000)
            }
            catch{
                print("Sleep broke")
            }
            
            await gameCard.action(self) // Execute the card action
            
            print("After: $\(self.money) Loc: \(self.location)") // Print player status after executing the card
            print("")
            
            print("----------")
            do {
                try await Task.sleep(nanoseconds: 3_000_000_000)
            }
            catch{
                print("Sleep broke")
            }
            print("")
            
            DispatchQueue.main.async {
                self.cardData.communityChestDrawIndex = ( self.cardData.communityChestDrawIndex + 1 ) % 16
            }
            do {
                try await Task.sleep(nanoseconds: 500_000_000)
            }
            catch{
                print("Sleep broke")
            }
            
        }
    }
}
