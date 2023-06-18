import SwiftUI
import Combine

class DiceAnimationData: ObservableObject {
    @Published var isFlashing: Bool = false
    @Published var flashingNumbers: [Int] = [1, 1]
    @Published var diceColor: Color = .orange
    @Published var isTwoDice: Bool = true
    
    init() {
        print("what's up doc")
    }
    
    private var timer: Timer?
    
    let diceRangeStart = 1
    let diceRangeEnd = 6
    
    func startDiceAnimationWrapper(isTwoDice: Bool = true) async -> [Int] {
        print("before startDice")
        self.isTwoDice = isTwoDice
        let results = await startDiceAnimation()
        return results
    }
    
    @MainActor
    func startDiceAnimation() async -> [Int] {
        print("Starting dice animation...")
        
        isFlashing = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            if self.isTwoDice {
                self.flashingNumbers = [
                    Int.random(in: self.diceRangeStart...self.diceRangeEnd),
                    Int.random(in: self.diceRangeStart...self.diceRangeEnd)
                ]
            } else {
                self.flashingNumbers = [
                    Int.random(in: self.diceRangeStart...self.diceRangeEnd)
                ]
            }
        }
        
        diceColor = Color(red: Double.random(in: 0...1),
                          green: Double.random(in: 0...1),
                          blue: Double.random(in: 0...1))
        
        do {
            print("do dice")
            try await Task.sleep(nanoseconds: 2_000_000_000) // Wait for 2 seconds
            
            pauseDiceAnimation()
            
            try await Task.sleep(nanoseconds: 4_000_000_000) // Wait for 4 seconds
            
            stopDiceAnimation()
            
        } catch {
            // Handle the error here
            print("An error occurred: \(error)")
        }
        
        print("Dice animation completed. Results: \(flashingNumbers)")
        return flashingNumbers
    }
    
    func pauseDiceAnimation() {
        print("Pausing dice animation...")
        
        timer?.invalidate()
        timer = nil
    }
    
    func stopDiceAnimation() {
        print("Stopping dice animation...")
        
        isFlashing = false
    }
}
