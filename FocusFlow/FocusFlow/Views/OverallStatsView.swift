import SwiftUI

struct OverallStatsView: View {
    @ObservedObject var taskViewModel: TaskViewModel
    @ObservedObject var noteViewModel: NoteViewModel
    let period: TimePeriod
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Загальна статистика")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                StatCard(
                    title: "Завдань виконано",
                    value: "\(completedTasksCount)",
                    icon: "checkmark.circle.fill",
                    color: .green
                )
                
                StatCard(
                    title: "Активних завдань",
                    value: "\(activeTasksCount)",
                    icon: "circle.dashed",
                    color: .blue
                )
                
                StatCard(
                    title: "Витрачено часу",
                    value: formattedTotalTime,
                    icon: "clock.fill",
                    color: .orange
                )
                
                StatCard(
                    title: "Нотаток створено",
                    value: "\(noteViewModel.notes.count)",
                    icon: "note.text",
                    color: .purple
                )
            }
            .padding(.horizontal)
        }
    }
    
    private var completedTasksCount: Int {
        filterTasksByPeriod(taskViewModel.completedTasks).count
    }
    
    private var activeTasksCount: Int {
        filterTasksByPeriod(taskViewModel.incompleteTasks).count
    }
    
    private var totalTimeSpent: TimeInterval {
        filterTasksByPeriod(taskViewModel.tasks)
            .reduce(0) { $0 + $1.timeSpent }
    }
    
    private var formattedTotalTime: String {
        let hours = Int(totalTimeSpent) / 3600
        let minutes = (Int(totalTimeSpent) % 3600) / 60
        if hours > 0 {
            return "\(hours)г \(minutes)хв"
        } else {
            return "\(minutes)хв"
        }
    }
    
    private func filterTasksByPeriod(_ tasks: [Task]) -> [Task] {
        let calendar = Calendar.current
        let now = Date()
        
        switch period {
        case .week:
            let weekAgo = calendar.date(byAdding: .day, value: -7, to: now)!
            return tasks.filter { $0.createdAt >= weekAgo }
        case .month:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now)!
            return tasks.filter { $0.createdAt >= monthAgo }
        case .all:
            return tasks
        }
    }
}
