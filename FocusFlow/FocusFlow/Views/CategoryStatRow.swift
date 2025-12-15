import SwiftUI

struct CategoryStatRow: View {
    let category: TaskCategory
    let count: Int
    let completed: Int
    
    var body: some View {
        HStack {
            Image(systemName: category.icon)
                .foregroundColor(colorFromString(category.color))
                .frame(width: 24)
            
            Text(category.name)
                .font(.subheadline)
            
            Spacer()
            
            Text("\(completed)/\(count)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if count > 0 {
                ProgressView(value: Double(completed), total: Double(count))
                    .frame(width: 60)
                    .tint(colorFromString(category.color))
            }
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
