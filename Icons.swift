//
//  Icons.swift
//  ClaraClaraGames
//
//  Created by James Philhower on 6/20/23.
//

import SwiftUI

struct Icons {
    /// Property Icons
    static var scooter: (Image, CGFloat, CGFloat) { adjustFrameForSymbol("scooter") }
    static var bicycle: (Image, CGFloat, CGFloat) { adjustFrameForSymbol("bicycle") }
    
    static var cablecar: (Image, CGFloat, CGFloat) { adjustFrameForSymbol("cablecar") }
    static var subway: (Image, CGFloat, CGFloat) { adjustFrameForSymbol("tram.fill.tunnel") }
    static var bus: (Image, CGFloat, CGFloat) { adjustFrameForSymbol("bus") }
        
    static var graduationCap: (Image, CGFloat, CGFloat) { adjustFrameForSymbol("graduationcap") }
    static var backpack: (Image, CGFloat, CGFloat) { adjustFrameForSymbol("backpack") }
    static var textBookClosed: (Image, CGFloat, CGFloat) { adjustFrameForSymbol("text.book.closed") }
    
    static var departure: (Image, CGFloat, CGFloat) { adjustFrameForSymbol("airplane.departure") }
    static var airplane: (Image, CGFloat, CGFloat) { adjustFrameForSymbol("airplane") }
    static var arrival: (Image, CGFloat, CGFloat) { adjustFrameForSymbol("airplane.arrival") }
    
    static var magazine: (Image, CGFloat, CGFloat) { adjustFrameForSymbol("magazine") }
    static var newspaper: (Image, CGFloat, CGFloat) { adjustFrameForSymbol("newspaper") }
    static var radio: (Image, CGFloat, CGFloat) { adjustFrameForSymbol("radio") }
    
    static var syringe: (Image, CGFloat, CGFloat) { adjustFrameForSymbol("syringe") }
    static var allergens: (Image, CGFloat, CGFloat) { adjustFrameForSymbol("allergens") }
    static var faceMask: (Image, CGFloat, CGFloat) { adjustFrameForSymbol("facemask") }
    
    static var crown: (Image, CGFloat, CGFloat) { adjustFrameForSymbol("crown")}
    static var congress: (Image, CGFloat, CGFloat) { adjustFrameForSymbol("building.columns")}
    
    static var cloud: (Image, CGFloat, CGFloat) { adjustFrameForSymbol("cloud")}
    static var wifi: (Image, CGFloat, CGFloat) { adjustFrameForSymbol("wifi")}
    static var cellularbars: (Image, CGFloat, CGFloat) { adjustFrameForSymbol("cellularbars")}

    static var plug: (Image, CGFloat, CGFloat) { adjustFrameForSymbol("powerplug")}
    static var outlet: (Image, CGFloat, CGFloat) { adjustFrameForSymbol("poweroutlet.type.b")}
    
    static var trainFront: (Image, CGFloat, CGFloat) {
        adjustFrameForSymbol("train.side.front.car")
    }
    static var trainMid: (Image, CGFloat, CGFloat) {
        adjustFrameForSymbol("train.side.middle.car")
    }
    static var trainEnd: (Image, CGFloat, CGFloat) {
        adjustFrameForSymbol("train.side.rear.car")
    }
    
    
    static var house: (Image, CGFloat, CGFloat) { adjustFrameForSymbol("house") }
    static var houseFill: (Image, CGFloat, CGFloat) { adjustFrameForSymbol("house.fill") }
    static var hotel: (Image, CGFloat, CGFloat) { adjustFrameForSymbol("house.lodge") }
    static var hotelFill: (Image, CGFloat, CGFloat) { adjustFrameForSymbol("house.lodge.fill") }

    
    private static func adjustFrameForSymbol(_ symbol: String) -> (Image, CGFloat, CGFloat) {
        let symbolSize = UIImage(systemName: symbol)?.size ?? CGSize(width: 1.0, height: 1.0)
        let symbolAspectRatio = symbolSize.width / symbolSize.height
        let adjustedWidth = iconHeight * symbolAspectRatio
        
        return (Image(systemName: symbol), iconHeight, adjustedWidth)
    }
    
    private static let iconHeight: CGFloat = 20
}
