import SwiftUI

struct TaskRowView: View {
    let task: Task
    let onToggle: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Checkbox
            Button(action: onToggle) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(task.isCompleted ? .green : .gray)
            }
            .buttonStyle(.plain)
            
            // Інформація про завдання
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.headline)
                    .strikethrough(task.isCompleted)
                
                if !task.description.isEmpty {
                    Text(task.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                HStack(spacing: 12) {
                    // Категорія
                    Label(task.category.name, systemImage: task.category.icon)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    // Дедлайн
                    if let deadline = task.deadline {
                        Label(deadline.formatted(date: .abbreviated, time: .omitted), systemImage: "calendar")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    // Час витрачений
                    if task.timeSpent > 0 {
                        Label(task.formattedTimeSpent, systemImage: "clock")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Видалити", systemImage: "trash")
            }
        }
    }
}
