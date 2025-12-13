import SwiftUI

struct IconButton: View {
    let icon: String
    let color: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? colorFromString(color).opacity(0.2) : Color(.systemGray6))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(isSelected ? colorFromString(color) : .primary)
                
                if isSelected {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(colorFromString(color), lineWidth: 2)
                        .frame(width: 50, height: 50)
                }
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
