import SwiftUI

struct CategoryStatsView: View {
    @ObservedObject var taskViewModel: TaskViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Завдання по категоріях")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            VStack(spacing: 8) {
                ForEach(taskViewModel.categories) { category in
                    CategoryStatRow(
                        category: category,
                        count: taskCount(for: category),
                        completed: completedCount(for: category)
                    )
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
    
    private func taskCount(for category: TaskCategory) -> Int {
        taskViewModel.tasks.filter { $0.category.id == category.id }.count
    }
    
    private func completedCount(for category: TaskCategory) -> Int {
        taskViewModel.tasks.filter {
            $0.category.id == category.id && $0.isCompleted
        }.count
    }
}
