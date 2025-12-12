import SwiftUI

struct CategoryFilterView: View {
    let categories: [TaskCategory]
    @Binding var selectedCategory: TaskCategory?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // Кнопка "Всі"
                CategoryChip(
                    name: "Всі",
                    icon: "square.grid.2x2",
                    color: .gray,
                    isSelected: selectedCategory == nil
                ) {
                    selectedCategory = nil
                }
                
                // Категорії
                ForEach(categories) { category in
                    CategoryChip(
                        name: category.name,
                        icon: category.icon,
                        color: colorFromString(category.color),
                        isSelected: selectedCategory?.id == category.id
                    ) {
                        selectedCategory = category
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemBackground))
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
