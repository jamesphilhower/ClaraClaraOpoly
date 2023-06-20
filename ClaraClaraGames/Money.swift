import SwiftUI

struct Bills: View {
    var body: some View {
        VStack {
            OneBillView()
            FiveBillView()
            TenBillView()
            TwentyBillView()
            FiftyBillView()
            HundredBillView()
            FiveHundredBillView()
        }
    }
}

struct OneBillView: View {
    var body: some View {
        BillBaseView(color: .blue)
    }
}

struct FiveBillView: View {
    var body: some View {
        BillBaseView(color: .green)
    }
}

struct TenBillView: View {
    var body: some View {
        BillBaseView(color: .red)
    }
}

struct TwentyBillView: View {
    var body: some View {
        BillBaseView(color: .purple)
    }
}

struct FiftyBillView: View {
    var body: some View {
        BillBaseView(color: .orange)
    }
}

struct HundredBillView: View {
    var body: some View {
        BillBaseView(color: .black)
    }
}

struct FiveHundredBillView: View {
    var body: some View {
        BillBaseView(color: .yellow)
    }
}

struct BillBaseView: View {
    let color: Color
    
    var body: some View {
        Image(systemName: "banknote")
            .foregroundColor(color)
            .font(.largeTitle)
    }
}

struct Bills_Previews: PreviewProvider {
    static var previews: some View {
         Bills()
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
