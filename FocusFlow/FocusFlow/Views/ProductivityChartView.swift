import SwiftUI
import Charts

struct ProductivityChartView: View {
    @ObservedObject var taskViewModel: TaskViewModel
    let period: TimePeriod
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Продуктивність")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            VStack(spacing: 8) {
                ForEach(productivityData) { item in
                    HStack {
                        Text(item.day)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(width: 50, alignment: .leading)
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color(.systemGray6))
                                    .frame(height: 20)
                                    .cornerRadius(4)
                                
                                if item.count > 0 {
                                    Rectangle()
                                        .fill(LinearGradient(
                                            gradient: Gradient(colors: [.blue, .blue.opacity(0.7)]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ))
                                        .frame(
                                            width: geometry.size.width * CGFloat(item.percentage),
                                            height: 20
                                        )
                                        .cornerRadius(4)
                                }
                            }
                        }
                        
                        Text("\(item.count)")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                            .frame(width: 30, alignment: .trailing)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 2)
                }
            }
            .padding(.vertical)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
    
    private var productivityData: [ProductivityData] {
        let calendar = Calendar.current
        let now = Date()
        
        let days: Int
        switch period {
        case .week:
            days = 7
        case .month:
            days = 30
        case .all:
            days = 30 // Показуємо останні 30 днів
        }
        
        let data = (0..<days).map { dayOffset in
            let date = calendar.date(byAdding: .day, value: -dayOffset, to: now)!
            let dayStart = calendar.startOfDay(for: date)
            let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart)!
            
            let count = taskViewModel.tasks.filter { task in
                task.isCompleted &&
                task.createdAt >= dayStart &&
                task.createdAt < dayEnd
            }.count
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM"
            
            return ProductivityData(
                day: formatter.string(from: date),
                count: count
            )
        }.reversed()
        
        // Обчислюємо відсотки відносно максимуму
        let maxCount = data.map { $0.count }.max() ?? 1
        return data.map { item in
            ProductivityData(
                day: item.day,
                count: item.count,
                percentage: maxCount > 0 ? Double(item.count) / Double(maxCount) : 0
            )
        }
    }
}

struct ProductivityData: Identifiable {
    let id = UUID()
    let day: String
    let count: Int
    var percentage: Double = 0
}
