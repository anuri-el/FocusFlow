import SwiftUI

struct PomodoroStatsView: View {
    @ObservedObject var taskViewModel: TaskViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Статистика Pomodoro")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            HStack(spacing: 12) {
                PomodoroStatCard(
                    title: "Всього часу",
                    value: totalTimeFormatted,
                    icon: "timer",
                    color: .red
                )
                
                PomodoroStatCard(
                    title: "Середній сеанс",
                    value: averageTimeFormatted,
                    icon: "clock.arrow.circlepath",
                    color: .blue
                )
            }
            .padding(.horizontal)
        }
    }
    
    private var totalTime: TimeInterval {
        taskViewModel.tasks.reduce(0) { $0 + $1.timeSpent }
    }
    
    private var totalTimeFormatted: String {
        let hours = Int(totalTime) / 3600
        if hours > 0 {
            return "\(hours)г"
        } else {
            let minutes = Int(totalTime) / 60
            return "\(minutes)хв"
        }
    }
    
    private var averageTimeFormatted: String {
        let tasksWithTime = taskViewModel.tasks.filter { $0.timeSpent > 0 }
        guard !tasksWithTime.isEmpty else { return "0хв" }
        
        let average = totalTime / Double(tasksWithTime.count)
        let minutes = Int(average) / 60
        return "\(minutes)хв"
    }
}
