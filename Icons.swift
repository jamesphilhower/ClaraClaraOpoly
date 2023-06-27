//
//  Icons.swift
//  ClaraClaraGames
//
//  Created by James Philhower on 6/20/23.
//

import SwiftUI

struct Icons {
    
    static var trainFront: some View  {
       standardizeFrameSize("train.side.front.car")
    }
    static var trainMid: some View  {
       standardizeFrameSize("train.side.middle.car")
    }
    static var trainEnd: some View  {
       standardizeFrameSize("train.side.rear.car")
    }
    
    static var plug:some View {standardizeFrameSize("powerplug")}
    static var outlet:some View {standardizeFrameSize("poweroutlet.type.b")}
    
    
    static var house: some View  {standardizeFrameSize("house") }
    static var houseFill: some View  {standardizeFrameSize("house.fill") }
    static var hotel: some View  {standardizeFrameSize("house.lodge") }
    static var hotelFill: some View  {standardizeFrameSize("house.lodge.fill") }  
}
let iconHeight: CGFloat = 20


func standardizeFrameSize(_ symbol: String) -> some View {
    let symbolSize = UIImage(systemName: symbol)?.size ?? CGSize(width: 1.0, height: 1.0)
    let symbolAspectRatio = symbolSize.width / symbolSize.height
    let adjustedWidth = iconHeight * symbolAspectRatio
    
    return Image(systemName: symbol).resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: adjustedWidth, height: iconHeight)
}
