import SwiftUI

struct CategoryManagementRow: View {
    let category: TaskCategory
    let taskCount: Int
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Іконка категорії
            ZStack {
                Circle()
                    .fill(colorFromString(category.color))
                    .frame(width: 50, height: 50)
                
                Image(systemName: category.icon)
                    .font(.title3)
                    .foregroundColor(.white)
            }
            
            // Інформація
            VStack(alignment: .leading, spacing: 4) {
                Text(category.name)
                    .font(.headline)
                
                Text("\(taskCount) завдань")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture {
            onEdit()
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            if taskCount == 0 {
                Button(role: .destructive) {
                    onDelete()
                } label: {
                    Label("Видалити", systemImage: "trash")
                }
            }
            
            Button {
                onEdit()
            } label: {
                Label("Редагувати", systemImage: "pencil")
            }
            .tint(.blue)
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
