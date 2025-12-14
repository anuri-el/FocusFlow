import SwiftUI

struct EditNoteFolderView: View {
    @ObservedObject var viewModel: NoteViewModel
    let folder: NoteFolder
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String
    @State private var selectedColor: String
    @State private var selectedIcon: String
    
    let availableColors = ["blue", "green", "purple", "red", "orange", "pink", "yellow"]
    let availableIcons = [
        "folder.fill", "person.fill", "briefcase.fill", "book.fill",
        "heart.fill", "star.fill", "lightbulb.fill", "flag.fill",
        "house.fill", "car.fill", "camera.fill", "leaf.fill"
    ]
    
    init(viewModel: NoteViewModel, folder: NoteFolder) {
        self.viewModel = viewModel
        self.folder = folder
        
        _name = State(initialValue: folder.name)
        _selectedColor = State(initialValue: folder.color)
        _selectedIcon = State(initialValue: folder.icon)
    }
    
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
            .navigationTitle("Редагувати папку")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Скасувати") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Зберегти") {
                        updateFolder()
                    }
                    .disabled(name.isEmpty)
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    private func updateFolder() {
        var updatedFolder = folder
        updatedFolder.name = name
        updatedFolder.color = selectedColor
        updatedFolder.icon = selectedIcon
        
        viewModel.updateFolder(updatedFolder)
        dismiss()
    }
}
