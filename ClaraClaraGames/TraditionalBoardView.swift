import SwiftUI


struct TraditionalGameBoardView: View {
    
    let boardSize: CGFloat = 11 // Total number of cells on the board
    let horizontalSpaceRatio: CGFloat = 0.7 // Ratio of width for horizontal spaces
    let verticalSpaceRatio: CGFloat = 0.7 // Ratio of height for vertical spaces
    let geometry: GeometryProxy
    @Binding  var cellCenters: [Int: CGPoint]
    
    var body: some View {
        let cornerSize: CGSize = calculateCornerCellSize(geometry)
        let verticalSize: CGSize = calculateNonCornerCellSize(geometry, horizontal: false)
        let horizontalSize: CGSize = calculateNonCornerCellSize(geometry, horizontal: true)
        
        VStack(spacing: 0) {
            /// Top Row
            HStack(spacing: 0) {
                CellView(index: 20 , cellSize: cornerSize, vertical: false)
                ForEach(Array(21..<30).reversed(), id: \.self) { index in
                    CellView(index: index , cellSize: horizontalSize, vertical: false)
                }
                CellView(index: 30 , cellSize: cornerSize, vertical: false)
            }
            .rotated(.degrees(180))
            
            
            HStack {
                /// left column
                HStack(spacing: 0) {
                    
                    ForEach(Array((11..<20).reversed()), id: \.self) { index in
                        CellView(index: index , cellSize: verticalSize, vertical: true)
                    }
                }
                .rotated(.degrees(90))
                
                /// Center Opening
                Spacer()
                    .frame(width: verticalSize.height * 9, height: verticalSize.height * 9)
                    .background(Color("Board"))
                    .overlay(SkyLineView())
                    .overlay(CardsView())
                /// Right column
                
                HStack(spacing: 0) {
                    
                    ForEach(Array(31..<40).reversed(), id: \.self) { index in
                        CellView(index: index , cellSize: verticalSize, vertical: true)
                    }
                }
                .rotated(.degrees(-90))
                
            } // Add trailing padding to the right VStack
            
            /// Bottom Row
            HStack(spacing: 0) {
                CellView(index: 10, cellSize: cornerSize, vertical: false)
                ForEach(Array((1..<10).reversed()), id: \.self) { index in
                    CellView(index: index , cellSize: horizontalSize, vertical: false)
                }
                CellView(index: 0, cellSize: cornerSize, vertical: false)
            }
        }
        .drawingGroup()
        .onAppear(){
            cellCenters = generateCenters(rotationAngle: 180)
        }
        .cornerRadius(5)
        .border(Color.black.opacity(0.5), width: 2)
        .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 2)
        .rotated(.degrees(180))
        .padding(.horizontal, 10)
        
    }
    
    func calculateNonCornerCellSize(_ geometry: GeometryProxy, horizontal: Bool) -> CGSize {
        let padding = 10
        let availableWidth = geometry.size.width
        let availableHeight = geometry.size.height
        let minSide = min(availableWidth, availableHeight) - CGFloat(2 * padding)
        let middleSpaces = boardSize - 2
        let unitsOfMiddleSpaces = middleSpaces * 0.7
        let portionTakenByMiddleSpaces = unitsOfMiddleSpaces / (unitsOfMiddleSpaces + 2)
        let side = minSide * portionTakenByMiddleSpaces / middleSpaces
        if horizontal {
            let cellWidth = side
            let cellHeight = side / horizontalSpaceRatio
            return CGSize(width: cellWidth, height: cellHeight)
        } else {
            let cellHeight = side
            let cellWidth = side / verticalSpaceRatio
            return CGSize(width: cellWidth, height: cellHeight)
        }
    }
    
    func calculateCornerCellSize(_ geometry: GeometryProxy) -> CGSize{
        let padding = 10
        let availableWidth = geometry.size.width
        let availableHeight = geometry.size.height
        let minSide = min(availableWidth, availableHeight) - CGFloat(2 * padding)
        let middleSpaces = boardSize - 2
        let unitsOfMiddleSpaces = middleSpaces * 0.7
        let portionTakenByMiddleSpaces = unitsOfMiddleSpaces / (unitsOfMiddleSpaces + 2)
        let width = minSide * (1 - portionTakenByMiddleSpaces) / 2
        let height = width
        return CGSize(width: width, height: height)
    }
    
    
    func generateCenters(rotationAngle: Int)->[Int: CGPoint]{
        
        let coordBase = geometry.frame(in: .global)
        let verticalSize: CGSize = calculateNonCornerCellSize(geometry, horizontal: false)
        let horizontalSize: CGSize = calculateNonCornerCellSize(geometry, horizontal: true)
        let cornerSize: CGSize = calculateCornerCellSize(geometry)
        
        var cellCenters: [Int: CGPoint] = [:] // Dictionary to store the centers of the cell views
        
        func incrementBottomRight(_ increment: CGSize){
            if vertical {
                curBottomRight.y += increment.height
            }
            else {
                curBottomRight.x += increment.width
            }
        }
        
        func resetTopLeft(){
            if vertical {
                curTopLeft.y = curBottomRight.y
            } else {
                curTopLeft.x = curBottomRight.x
            }
        }
        
        func addMidpoint(){
            let midPoint: CGPoint = CGPoint(x: (curTopLeft.x + curBottomRight.x) / 2, y: (curTopLeft.y + curBottomRight.y) / 2)
            cellCenters[index] = midPoint
        }
        
        // Top row
        var index: Int = 20
        var vertical: Bool = false
        var curTopLeft = CGPoint(x: 10, y: 0)
        var curBottomRight = CGPoint(x: 10 + cornerSize.width , y: cornerSize.height)
        addMidpoint()
        resetTopLeft()
        for loopIndex in (21..<30) {
            index = loopIndex
            incrementBottomRight(horizontalSize)
            addMidpoint()
            resetTopLeft()
        }
        index = 30
        incrementBottomRight(cornerSize)
        addMidpoint()
        
        // Left Column
        curTopLeft.x = 10 + coordBase.minX
        curTopLeft.y = cornerSize.height //+ coordBase.minY
        curBottomRight.x = 10 + cornerSize.width
        vertical = true
        for loopIndex in (11..<20).reversed(){
            index = loopIndex
            incrementBottomRight(verticalSize)
            addMidpoint()
            resetTopLeft()
        }
        index = 10
        incrementBottomRight(cornerSize)
        addMidpoint()
        //Right Column
        curTopLeft.x = geometry.frame(in: .global).maxX - 10 - cornerSize.width
        curTopLeft.y = cornerSize.height // move down height of corner
        curBottomRight.x = geometry.frame(in: .global).maxX - 10 // move to right side minus padding
        curBottomRight.y = cornerSize.height
        for loopIndex in (31..<40){
            index = loopIndex
            incrementBottomRight(verticalSize)
            addMidpoint()
            resetTopLeft()
        }
        // Bottom Row
        // Bottom Right
        index = 0
        incrementBottomRight(cornerSize)
        addMidpoint()
        vertical = false
        curTopLeft.x = 10 + cornerSize.width + coordBase.minX
        curBottomRight.x = 10 + cornerSize.width + coordBase.minX
        
        for loopIndex in (1..<10).reversed() {
            index = loopIndex
            incrementBottomRight(horizontalSize)
            addMidpoint()
            resetTopLeft()
        }
        var updatedCenters: [Int: CGPoint] = [:] // Dictionary to store the updated cell centers

        for (index, center) in cellCenters {
                updatedCenters[index] = center
            }
            
            // Apply rotation
            switch rotationAngle {
            case 90: // Rotate by 90 degrees
                for (index, _) in cellCenters {
                    let newIndex = (index + 10) % 39
                    let newCenter = cellCenters[newIndex]
                    updatedCenters[index] = newCenter
                }
            case 180: // Rotate by 180 degrees
                for (index, _) in cellCenters {
                    let newIndex = (index + 20) % 40
                    let newCenter = cellCenters[newIndex]
                    updatedCenters[index] = newCenter
                }
            case 270: // Rotate by 270 degrees
                for (index, _) in cellCenters {
                    let newIndex = (index + 30) % 39
                    let newCenter = cellCenters[newIndex]
                    updatedCenters[index] = newCenter
                }
            default:
                break
            }
            
            return updatedCenters
    }
}

