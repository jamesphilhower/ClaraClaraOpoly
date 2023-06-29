import SwiftUI
import Combine

class DiceAnimationData: ObservableObject {
    @Published var isFlashing: Bool = false
    @Published var flashingNumbers: [Int] = [1, 1]
    @Published var diceColor: Color = .orange
    @Published var isTwoDice: Bool = true
    
    private var timer: Timer?
    
    let diceRangeStart = 1
    let diceRangeEnd = 6
    
    @MainActor
    func startDiceAnimationWrapper(isTwoDice: Bool = true) async -> [Int] {
        self.isTwoDice = isTwoDice
        let results = await startDiceAnimation()
        return [19, 21]//results
    }
    /// Todo prevent from starting two dice rolls at the same time
    @MainActor
    func startDiceAnimation() async -> [Int] {
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
//            try await Task.sleep(nanoseconds: 2_000_000_000) // Wait for 2 seconds
                        try await Task.sleep(nanoseconds: 500_000_000) // Wait for 2 seconds

            pauseDiceAnimation()
            
            try await Task.sleep(nanoseconds: 1_000_000_000) // Wait for 4 seconds
            
            stopDiceAnimation()
            
        } catch {
            // Handle the error here
            print("An error occurred: \(error)")
        }
        
        return flashingNumbers
    }
    
    func pauseDiceAnimation() {
        
        timer?.invalidate()
        timer = nil
    }
    
    func stopDiceAnimation() {        
        isFlashing = false
    }
}
