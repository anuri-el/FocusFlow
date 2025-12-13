import SwiftUI

struct ColorCircle: View {
    let color: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(colorFromString(color))
                    .frame(width: 50, height: 50)
                
                if isSelected {
                    Circle()
                        .stroke(colorFromString(color), lineWidth: 3)
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .font(.title3)
                        .fontWeight(.bold)
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
