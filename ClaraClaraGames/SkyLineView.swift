//
//  SkyLineView.swift
//  ClaraClaraGames
//
//  Created by James Philhower on 6/25/23.
//

import SwiftUI

struct SkyLineView: View {
    let scaleFactor: CGFloat = 1
    @State var moveDown = 0
    
    func getRandomColor()->Color{
        let colors: [Color] = [
            .gray,
        ]
        return colors.randomElement()!
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: -60) {
                    buildRow(of: 6, with: geometry)
                    buildRow(of: 6, with: geometry)
                    buildRow(of: 6, with: geometry)
                }
                .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                .clipped()
                
                VStack {
                    Text("Clara")
                        .font(.system(size: 90))
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                        .offset(x: 0)
                    Text("Clara")
                        .font(.system(size: 80))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Text("Opoly")
                        .font(.system(size: 70))
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .offset(x: 45)
                }
            }
            .drawingGroup()
        }
    }

    func buildRow(of count: Int, with geometry: GeometryProxy) -> some View {
        HStack(spacing: 20) {
            ForEach(0..<count) { _ in
                buildRandomImage()
                    .resizable()
                    .offset(x: CGFloat.random(in: 10...20), y: CGFloat.random(in: 10...20))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: randomBuildingSize() * scaleFactor, height: randomBuildingSize())
                    .foregroundColor(getRandomColor())
            }
        }
    }

    func buildRandomImage() -> Image {
        let randomBuildingImage = getRandomBuildingImage()
        return Image(systemName: randomBuildingImage)
    }

    func randomBuildingSize() -> CGFloat {
        return CGFloat.random(in: 60...100)
    }

    func getRandomBuildingImage() -> String {
        let buildingImages = [
            "building.fill",
            "building",
            "building.2.fill",
            "building.columns",
        ]
        
        return buildingImages.randomElement() ?? "building.2.fill"
    }
}

struct SkyLineView_Previews: PreviewProvider {
    static var previews: some View {
        SkyLineView()
    }
}
