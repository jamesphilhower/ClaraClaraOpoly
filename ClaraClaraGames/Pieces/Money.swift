import SwiftUI

enum BillType: Int, CustomStringConvertible {
    case one = 1
    case five = 5
    case ten = 10
    case twenty = 20
    case fifty = 50
    case hundred = 100
    case fiveHundred = 500
    
    var description: String {
        switch self {
        case .one, .five:
            return " \(rawValue) "
        case .ten, .twenty, .fifty:
            return "\(rawValue)"
        case .hundred:
            return "\(rawValue)"
        case .fiveHundred:
            return "\(rawValue)"
        }
    }
}


func getBillColor(for value: Int) -> Color {
        switch value {
        case 500:
            return .black
        case 100:
            return .blue
        case 50:
            return .green
        case 20:
            return .red
        case 10:
            return .purple
        case 5:
            return .orange
        case 1:
            return .gray
        default:
            return .gray
        }
    }



struct BillsView: View {
    let bills: [String: Int]
    
    var body: some View {
        HStack(spacing: 2){
            ForEach(bills.sorted(by: { Int($0.key.dropLast()) ?? 0 > Int($1.key.dropLast()) ?? 0 }), id: \.key) { bill in
                let (value, count) = bill
                let billValue = BillType(rawValue: Int(value.dropLast()) ?? 0) ?? .one
                let billCount = count
                let color = getBillColor(for: billValue.rawValue)
                let fontSize: CGFloat = (billValue == .hundred || billValue == .fiveHundred) ? 19 : 20

                ZStack {
                    ForEach(0..<billCount, id: \.self) { index in
                        BillBaseView(color: color, value: billValue, fontSize: fontSize)
                            .offset(x: CGFloat(index * 4), y: CGFloat(index * 4))
                    }
                }.padding(EdgeInsets(top: 0, leading: 0, bottom: CGFloat(billCount * 4), trailing: CGFloat(billCount * 4)))

            }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}


struct BillBaseView: View {
    let color: Color
    let value: BillType
    let fontSize: CGFloat
    
    var body: some View {
        Image(systemName: "banknote")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(color)
            .overlay(
                Text(value.description)
                    .foregroundColor(color)
                    .font(.system(size: fontSize))
                    .background(.white)
                    .offset(x: 0, y: 0)
            )
            .background(.white)
            .frame(width: 50)
            .rotationEffect(Angle(degrees: 90))
            .frame(width: 32)
    }
}

struct BillsView_Previews: PreviewProvider {
    static var previews: some View {
        let bills: [String: Int] = calculateBills(for: 3289)
        
        return BillsView(bills: bills)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

func calculateBills(for charge: Int) -> [String: Int] {
    let billValues: [Int] = [500, 100, 50, 20, 10, 5, 1]
    var remainingCharge = charge
    var billCounts: [String: Int] = [:]
    
    for value in billValues {
        let count = remainingCharge / value
        if count > 0 {
            billCounts["\(value)$"] = count
            remainingCharge -= count * value
        }
    }
    
    return billCounts
}
