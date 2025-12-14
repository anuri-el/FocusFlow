import SwiftUI

struct FolderChip: View {
    let name: String
    let icon: String
    let color: Color
    let count: Int?
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(isSelected ? color : Color(.systemGray5))
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(isSelected ? .white : .primary)
                }
                
                VStack(spacing: 2) {
                    Text(name)
                        .font(.caption)
                        .fontWeight(isSelected ? .semibold : .regular)
                        .foregroundColor(.primary)
                    
                    if let count = count {
                        Text("\(count)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .buttonStyle(.plain)
    }
}
