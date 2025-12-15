import SwiftUI

struct TimeSpentChartView: View {
    @ObservedObject var taskViewModel: TaskViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Час по категоріях")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            VStack(spacing: 8) {
                ForEach(categoryTimeData) { item in
                    HStack {
                        Circle()
                            .fill(item.color)
                            .frame(width: 12, height: 12)
                        
                        Text(item.category)
                            .font(.subheadline)
                        
                        Spacer()
                        
                        Text(item.formattedTime)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        // Прогрес бар
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color(.systemGray5))
                                    .frame(height: 8)
                                    .cornerRadius(4)
                                
                                Rectangle()
                                    .fill(item.color)
                                    .frame(
                                        width: geometry.size.width * CGFloat(item.percentage),
                                        height: 8
                                    )
                                    .cornerRadius(4)
                            }
                        }
                        .frame(width: 80, height: 8)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                }
            }
            .padding(.vertical)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
    
    private var categoryTimeData: [CategoryTimeData] {
        let totalTime = taskViewModel.tasks.reduce(0.0) { $0 + $1.timeSpent }
        
        return taskViewModel.categories.compactMap { category in
            let time = taskViewModel.tasks
                .filter { $0.category.id == category.id }
                .reduce(0) { $0 + $1.timeSpent }
            
            if time > 0 {
                return CategoryTimeData(
                    category: category.name,
                    time: time,
                    color: colorFromString(category.color),
                    percentage: totalTime > 0 ? time / totalTime : 0
                )
            }
            return nil
        }
    }
    
    private func colorFromString(_ colorName: String) -> Color {
        switch colorName {
        case "blue": return .blue
        case "green": return .green
        case "purple": return .purple
        case "red": return .red
        case "orange": return .orange
        case "pink": return .pink
        case "yellow": return .yellow
        default: return .gray
        }
    }
}
