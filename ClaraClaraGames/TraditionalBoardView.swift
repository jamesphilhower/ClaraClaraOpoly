import SwiftUI


struct TraditionalGameBoardView: View {
    
    let boardSize: CGFloat = 11 // Total number of cells on the board
    let horizontalSpaceRatio: CGFloat = 0.7 // Ratio of width for horizontal spaces
    let verticalSpaceRatio: CGFloat = 0.7 // Ratio of height for vertical spaces
    let geometry: GeometryProxy
    
    @Binding   var cellCenters: [Int: CGPoint]
    @Binding var rotationAngle: Double
    
    var body: some View {
        let cornerSize: CGSize = calculateCornerCellSize(geometry)
        let verticalSize: CGSize = calculateNonCornerCellSize(geometry, horizontal: false)
        let horizontalSize: CGSize = calculateNonCornerCellSize(geometry, horizontal: true)
        
        let topRowRange = 21..<30
        let leftColumnRange = 11..<20
        let rightColumnRange = 31..<40
        let bottomRowRange = 1..<10
        
        let topRowHStack =
        VStack {
            HStack( spacing: 0) {
                
                CellView(index: 30 , cellSize: cornerSize, vertical: false)
                ForEach(Array(topRowRange).reversed(), id: \.self) { index in
                    CellView(index: index , cellSize: horizontalSize, vertical: false)
                }
                CellView(index: 20 , cellSize: cornerSize, vertical: false)
            }.zIndex(1)
            BillsView(bills: calculateBills(for: 1357)).offset(y: -35).zIndex(0)
            Spacer()
        }
        .frame(height: 150)
        .rotated(.degrees(180))
        
        let leftColumnHStack =
        VStack {
            HStack(spacing: 0) {
                ForEach(Array(leftColumnRange).reversed(), id: \.self) { index in
                    CellView(index: index , cellSize: verticalSize, vertical: true)
                }
            }.zIndex(1)
            BillsView(bills: calculateBills(for: 1356)).offset(y: -35).zIndex(0)
            Spacer()
        }
        .frame(height: 150)
        .rotated(.degrees(90))
        
        let rightColumnHStack =
        VStack{
            HStack(spacing: 0) {
                ForEach(Array(rightColumnRange).reversed(), id: \.self) { index in
                    CellView(index: index , cellSize: verticalSize, vertical: true)
                }
            }.zIndex(1)
            BillsView(bills: calculateBills(for: 0)).offset(y: -35).zIndex(0)
            Spacer()
        }
        .frame(height: 150)
        .rotated(.degrees(-90))
        
        let bottomRowHStack =
        VStack{
            HStack(spacing: 0) {
                CellView(index: 10, cellSize: cornerSize, vertical: false)
                ForEach(Array(bottomRowRange).reversed(), id: \.self) { index in
                    CellView(index: index , cellSize: horizontalSize, vertical: false)
                }
                CellView(index: 0, cellSize: cornerSize, vertical: false)
            }.zIndex(1)
            BillsView(bills: calculateBills(for: 1398)).offset(y: -35).zIndex(0)
            Spacer()
            
        }
        .frame(height: 150)
        
        VStack(alignment: .center, spacing: -1) {
            topRowHStack
            
            HStack {
                leftColumnHStack
                Spacer()
                    .frame(width: verticalSize.height * 9, height: verticalSize.height * 9)
                    .background(Color("Board"))
                    .overlay(SkyLineView())
                    .overlay(CardsView(rotationAngle: rotationAngle))
                rightColumnHStack
            }
            
            bottomRowHStack
        }
        .drawingGroup()
        .onAppear(){
            // Todo make this angle the same as below
            // Todo make this angle a global so it changes automatically with turns
            cellCenters = generateCenters(rotationAngle: Int(-rotationAngle))
        }
        .onChange(of: rotationAngle){ ang in
            print(ang)
            cellCenters = generateCenters(rotationAngle: Int(-rotationAngle))
        }
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .fill(.clear)
                .frame(width: geometry.size.width - 18, height: geometry.size.width - 18)
                .border(Color.black.opacity(0.5), width: 2)
                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 2)
        )
        // Todo make this angle the same as above
        .rotated(.degrees(-rotationAngle))
//        .padding(.horizontal, 10)
        
    }
    
    private func calculateNonCornerCellSize(_ geometry: GeometryProxy, horizontal: Bool) -> CGSize {
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
    
    private func calculateCornerCellSize(_ geometry: GeometryProxy) -> CGSize{
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
    
    private let padding: CGFloat = 10
    // Todo we need the centers to be saved and not recalculated from the beginning
    private func generateCenters(rotationAngle: Int)->[Int: CGPoint]{
        
        let coordBase = geometry.frame(in: .local)
        let verticalSize: CGSize = calculateNonCornerCellSize(geometry, horizontal: false)
        let horizontalSize: CGSize = calculateNonCornerCellSize(geometry, horizontal: true)
        let cornerSize: CGSize = calculateCornerCellSize(geometry)
        // Todo make this a struct or some type
        var cellCenters: [Int: CGPoint] = [:]
        
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
        var curTopLeft = CGPoint(x: padding, y: 0)
        var curBottomRight = CGPoint(x: padding + cornerSize.width , y: cornerSize.height)
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
        curTopLeft.x = padding + coordBase.minX
        curTopLeft.y = cornerSize.height //+ coordBase.minY
        curBottomRight.x = padding + cornerSize.width
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
        curTopLeft.x = geometry.frame(in: .global).maxX - padding - cornerSize.width
        curTopLeft.y = cornerSize.height // move down height of corner
        curBottomRight.x = geometry.frame(in: .global).maxX - padding // move to right side minus padding
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
        curTopLeft.x = padding + cornerSize.width + coordBase.minX
        curBottomRight.x = padding + cornerSize.width + coordBase.minX
        
        for loopIndex in (1..<10).reversed() {
            index = loopIndex
            incrementBottomRight(horizontalSize)
            addMidpoint()
            resetTopLeft()
        }
        // Todo fill in with type from above
        var updatedCenters: [Int: CGPoint] = [:]
        for (index, center) in cellCenters {
            updatedCenters[index] = center
        }
        
        // Apply rotation
        switch rotationAngle {
        case -270: // Rotate by 90 degrees
            for (index, _) in cellCenters {
                let newIndex = (index + 10) % 40
                let newCenter = cellCenters[newIndex]
                updatedCenters[index] = newCenter
            }
        case -180: // Rotate by 180 degrees
            for (index, _) in cellCenters {
                let newIndex = (index + 20) % 40
                let newCenter = cellCenters[newIndex]
                updatedCenters[index] = newCenter
            }
        case -90: // Rotate by 270 degrees
            for (index, _) in cellCenters {
                let newIndex = (index + 30) % 40
                let newCenter = cellCenters[newIndex]
                updatedCenters[index] = newCenter
            }
        default:
            break
        }
        
        return updatedCenters
    }
}

