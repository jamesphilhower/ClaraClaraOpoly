//
//  Icons.swift
//  ClaraClaraGames
//
//  Created by James Philhower on 6/20/23.
//

import SwiftUI

struct Icons {
    /// Property Icons
    static var scooter: (Image, CGFloat, CGFloat) { adjustFrameForSymbolBuildable("scooter") }
    static var bicycle: (Image, CGFloat, CGFloat) { adjustFrameForSymbolBuildable("bicycle") }
    
    static var cablecar: (Image, CGFloat, CGFloat) { adjustFrameForSymbolBuildable("cablecar") }
    static var subway: (Image, CGFloat, CGFloat) { adjustFrameForSymbolBuildable("tram.fill.tunnel") }
    static var bus: (Image, CGFloat, CGFloat) { adjustFrameForSymbolBuildable("bus") }
        
    static var graduationCap: (Image, CGFloat, CGFloat) { adjustFrameForSymbolBuildable("graduationcap") }
    static var backpack: (Image, CGFloat, CGFloat) { adjustFrameForSymbolBuildable("backpack") }
    static var textBookClosed: (Image, CGFloat, CGFloat) { adjustFrameForSymbolBuildable("text.book.closed") }
    
    static var departure: (Image, CGFloat, CGFloat) { adjustFrameForSymbolBuildable("airplane.departure") }
    static var airplane: (Image, CGFloat, CGFloat) { adjustFrameForSymbolBuildable("airplane") }
    static var arrival: (Image, CGFloat, CGFloat) { adjustFrameForSymbolBuildable("airplane.arrival") }
    
    static var magazine: (Image, CGFloat, CGFloat) { adjustFrameForSymbolBuildable("magazine") }
    static var newspaper: (Image, CGFloat, CGFloat) { adjustFrameForSymbolBuildable("newspaper") }
    static var radio: (Image, CGFloat, CGFloat) { adjustFrameForSymbolBuildable("radio") }
    
    static var syringe: (Image, CGFloat, CGFloat) { adjustFrameForSymbolBuildable("syringe") }
    static var allergens: (Image, CGFloat, CGFloat) { adjustFrameForSymbolBuildable("allergens") }
    static var faceMask: (Image, CGFloat, CGFloat) { adjustFrameForSymbolBuildable("facemask") }
    
    static var crown: (Image, CGFloat, CGFloat) { adjustFrameForSymbolBuildable("crown")}
    static var congress: (Image, CGFloat, CGFloat) { adjustFrameForSymbolBuildable("building.columns")}
    
    static var cloud: (Image, CGFloat, CGFloat) { adjustFrameForSymbolBuildable("cloud")}
    static var wifi: (Image, CGFloat, CGFloat) { adjustFrameForSymbolBuildable("wifi")}
    static var cellularbars: (Image, CGFloat, CGFloat) { adjustFrameForSymbolBuildable("cellularbars")}

    static var plug:some View {adjustFrameForSymbolNonBuildable("powerplug")}
    static var outlet:some View {adjustFrameForSymbolNonBuildable("poweroutlet.type.b")}
    
    
    static var trainFront: some View  {
       adjustFrameForSymbolNonBuildable("train.side.front.car")
    }
    static var trainMid: some View  {
       adjustFrameForSymbolNonBuildable("train.side.middle.car")
    }
    static var trainEnd: some View  {
       adjustFrameForSymbolNonBuildable("train.side.rear.car")
    }
    
    
    static var house: some View  {adjustFrameForSymbolNonBuildable("house") }
    static var houseFill: some View  {adjustFrameForSymbolNonBuildable("house.fill") }
    static var hotel: some View  {adjustFrameForSymbolNonBuildable("house.lodge") }
    static var hotelFill: some View  {adjustFrameForSymbolNonBuildable("house.lodge.fill") }

    
    private static func adjustFrameForSymbolNonBuildable(_ symbol: String) -> some View {
        let symbolSize = UIImage(systemName: symbol)?.size ?? CGSize(width: 1.0, height: 1.0)
        let symbolAspectRatio = symbolSize.width / symbolSize.height
        let adjustedWidth = iconHeight * symbolAspectRatio
        
        return Image(systemName: symbol).resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: adjustedWidth, height: iconHeight)
    }
    
    private static func adjustFrameForSymbolBuildable(_ symbol: String) -> (Image, CGFloat, CGFloat) {
        let symbolSize = UIImage(systemName: symbol)?.size ?? CGSize(width: 1.0, height: 1.0)
        let symbolAspectRatio = symbolSize.width / symbolSize.height
        let adjustedWidth = iconHeight * symbolAspectRatio
        
        return (Image(systemName: symbol), iconHeight, adjustedWidth)
    }
    
    
    private static let iconHeight: CGFloat = 20
}
