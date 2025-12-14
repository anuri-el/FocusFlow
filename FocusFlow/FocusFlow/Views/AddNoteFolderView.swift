import SwiftUI

struct AddNoteFolderView: View {
    @ObservedObject var viewModel: NoteViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var selectedColor = "blue"
    @State private var selectedIcon = "folder.fill"
    
    let availableColors = ["blue", "green", "purple", "red", "orange", "pink", "yellow"]
    let availableIcons = [
        "folder.fill", "person.fill", "briefcase.fill", "book.fill",
        "heart.fill", "star.fill", "lightbulb.fill", "flag.fill",
        "house.fill", "car.fill", "camera.fill", "leaf.fill"
    ]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Назва папки")) {
                    TextField("Введіть назву", text: $name)
                }
                
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
            }
            .navigationTitle("Нова папка")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Скасувати") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Створити") {
                        viewModel.addFolder(name: name, icon: selectedIcon, color: selectedColor)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                    .fontWeight(.semibold)
                }
            }
        }
    }
}
