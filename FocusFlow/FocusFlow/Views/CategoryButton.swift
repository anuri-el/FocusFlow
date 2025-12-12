import SwiftUI

struct CategoryButton: View {
    let category: TaskCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(colorFromString(category.color))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: category.icon)
                        .font(.title2)
                        .foregroundColor(.white)
                    
                    if isSelected {
                        Circle()
                            .stroke(colorFromString(category.color), lineWidth: 3)
                            .frame(width: 70, height: 70)
                    }
                }
                
                Text(category.name)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
        }
        .buttonStyle(.plain)
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
