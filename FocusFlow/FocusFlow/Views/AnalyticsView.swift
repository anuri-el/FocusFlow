import SwiftUI

struct AnalyticsView: View {
    @StateObject private var taskViewModel = TaskViewModel()
    @StateObject private var noteViewModel = NoteViewModel()
    @State private var selectedPeriod: TimePeriod = .week
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Вибір періоду
                    PeriodPicker(selectedPeriod: $selectedPeriod)
                        .padding(.horizontal)
                    
                    // Загальна статистика
                    OverallStatsView(
                        taskViewModel: taskViewModel,
                        noteViewModel: noteViewModel,
                        period: selectedPeriod
                    )
                    
                    // Завдання по категоріях
                    CategoryStatsView(taskViewModel: taskViewModel)
                    
                    // Час по категоріях
                    TimeSpentChartView(taskViewModel: taskViewModel)
                    
                    // Продуктивність по днях
                    ProductivityChartView(
                        taskViewModel: taskViewModel,
                        period: selectedPeriod
                    )
                    
                    // Статистика Pomodoro
                    PomodoroStatsView(taskViewModel: taskViewModel)
                    
                    // Статистика нотаток
                    NotesStatsView(noteViewModel: noteViewModel)
                }
                .padding(.vertical)
            }
            .navigationTitle("Аналітика")
            .background(Color(.systemGroupedBackground))
        }
    }
}
