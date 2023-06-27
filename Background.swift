//
//  Background.swift
//  ClaraClaraGames
//
//  Created by James Philhower on 6/22/23.
//

import SwiftUI


struct WoodGrainBackground: View {
    
    let numberOfPanels: Int = 30
    let maxRotation: Double
    let maxRandomness: CGFloat
    
    init(maxRotation: Double, maxRandomness: CGFloat) {
        self.maxRotation = maxRotation
        self.maxRandomness = maxRandomness
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(red: 213/255, green: 184/255, blue: 147/255)
                ForEach(0..<30) { index in
                    let rotation = Double.random(in: -maxRotation...maxRotation)
                    let randomness = CGFloat.random(in: -maxRandomness...maxRandomness)
                    let xOffset = CGFloat(index) * (geometry.size.width / CGFloat(numberOfPanels))
                    let woodColor = Color(red: 224/255 + Double.random(in: -0.05...0.05),
                                          green: 216/255 + Double.random(in: -0.05...0.05),
                                          blue: 165/255 + Double.random(in: -0.05...0.05))
                    
                    Rectangle()
                        .fill(LinearGradient(gradient: .init(colors: [woodColor.opacity(0.9), woodColor.opacity(1.0)]), startPoint: .leading, endPoint: .trailing))
                        .frame(width: CGFloat(geometry.size.width * 2) / CGFloat(numberOfPanels), height: geometry.size.height)
                        .rotationEffect(.degrees(rotation))
                        .offset(x: xOffset - 20 + randomness - geometry.size.width / 2)
                }
            }
            .drawingGroup()
        }
    }
}
