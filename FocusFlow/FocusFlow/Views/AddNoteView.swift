import SwiftUI

struct AddNoteView: View {
    @ObservedObject var viewModel: NoteViewModel
    let folderId: UUID?
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var content = ""
    @State private var selectedFolderId: UUID?
    @State private var tags: [String] = []
    @State private var tagInput = ""
    
    init(viewModel: NoteViewModel, folderId: UUID? = nil) {
        self.viewModel = viewModel
        self.folderId = folderId
        _selectedFolderId = State(initialValue: folderId)
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Заголовок
                Section {
                    TextField("Заголовок нотатки", text: $title)
                        .font(.headline)
                }
                
                // Вміст
                Section(header: Text("Вміст")) {
                    TextEditor(text: $content)
                        .frame(minHeight: 200)
                }
                
                // Папка
                Section(header: Text("Папка")) {
                    Picker("Оберіть папку", selection: $selectedFolderId) {
                        Text("Без папки").tag(nil as UUID?)
                        ForEach(viewModel.folders) { folder in
                            HStack {
                                Image(systemName: folder.icon)
                                Text(folder.name)
                            }
                            .tag(folder.id as UUID?)
                        }
                    }
                }
                
                // Теги
                Section(header: Text("Теги")) {
                    // Додавання тегу
                    HStack {
                        TextField("Додати тег", text: $tagInput)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                        
                        Button {
                            addTag()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                        }
                        .disabled(tagInput.isEmpty)
                    }
                    
                    // Список тегів
                    if !tags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(tags, id: \.self) { tag in
                                    TagView(tag: tag) {
                                        tags.removeAll { $0 == tag }
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Нова нотатка")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Скасувати") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Зберегти") {
                        saveNote()
                    }
                    .disabled(title.isEmpty)
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    private func addTag() {
        let trimmedTag = tagInput.trimmingCharacters(in: .whitespaces)
        if !trimmedTag.isEmpty && !tags.contains(trimmedTag) {
            tags.append(trimmedTag)
            tagInput = ""
        }
    }
    
    private func saveNote() {
        viewModel.addNote(
            title: title,
            content: content,
            folderId: selectedFolderId,
            tags: tags
        )
        dismiss()
    }
}
