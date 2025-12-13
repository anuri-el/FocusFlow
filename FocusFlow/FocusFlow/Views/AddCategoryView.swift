import SwiftUI

struct AddCategoryView: View {
    @ObservedObject var viewModel: TaskViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var selectedColor = "blue"
    @State private var selectedIcon = "folder.fill"
    
    let availableColors = ["blue", "green", "purple", "red", "orange", "pink", "yellow"]
    let availableIcons = [
        "folder.fill", "briefcase.fill", "book.fill", "person.fill",
        "heart.fill", "star.fill", "flag.fill", "cart.fill",
        "house.fill", "car.fill", "airplane", "gamecontroller.fill",
        "music.note", "camera.fill", "paintbrush.fill", "leaf.fill"
    ]
    
    var body: some View {
        NavigationView {
            Form {
                // Назва
                Section(header: Text("Назва категорії")) {
                    TextField("Введіть назву", text: $name)
                }
                
                // Колір
                Section(header: Text("Колір")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(availableColors, id: \.self) { color in
                                ColorCircle(
                                    color: color,
                                    isSelected: selectedColor == color
                                ) {
                                    selectedColor = color
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                // Іконка
                Section(header: Text("Іконка")) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 16) {
                        ForEach(availableIcons, id: \.self) { icon in
                            IconButton(
                                icon: icon,
                                color: selectedColor,
                                isSelected: selectedIcon == icon
                            ) {
                                selectedIcon = icon
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // Попередній перегляд
                Section(header: Text("Попередній перегляд")) {
                    HStack {
                        Spacer()
                        
                        VStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(colorFromString(selectedColor))
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: selectedIcon)
                                    .font(.system(size: 36))
                                    .foregroundColor(.white)
                            }
                            
                            Text(name.isEmpty ? "Назва категорії" : name)
                                .font(.headline)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Нова категорія")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Скасувати") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Створити") {
                        viewModel.addCategory(name: name, color: selectedColor, icon: selectedIcon)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                    .fontWeight(.semibold)
                }
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
