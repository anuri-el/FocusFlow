import SwiftUI

enum TimePeriod: String, CaseIterable {
    case week = "Тиждень"
    case month = "Місяць"
    case all = "Весь час"
}

struct PeriodPicker: View {
    @Binding var selectedPeriod: TimePeriod
    
    var body: some View {
        Picker("Період", selection: $selectedPeriod) {
            ForEach(TimePeriod.allCases, id: \.self) { period in
                Text(period.rawValue).tag(period)
            }
        }
        .pickerStyle(.segmented)
    }
}
