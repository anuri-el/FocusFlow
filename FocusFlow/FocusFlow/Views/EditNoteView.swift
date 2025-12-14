import SwiftUI

struct EditNoteView: View {
    @ObservedObject var viewModel: NoteViewModel
    let note: Note
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String
    @State private var content: String
    @State private var selectedFolderId: UUID?
    @State private var tags: [String]
    @State private var tagInput = ""
    
    init(viewModel: NoteViewModel, note: Note) {
        self.viewModel = viewModel
        self.note = note
        
        _title = State(initialValue: note.title)
        _content = State(initialValue: note.content)
        _selectedFolderId = State(initialValue: note.folderId)
        _tags = State(initialValue: note.tags)
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
                
                // Інформація
                Section(header: Text("Інформація")) {
                    HStack {
                        Text("Створено")
                        Spacer()
                        Text(note.formattedCreatedDate)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Оновлено")
                        Spacer()
                        Text(note.formattedUpdatedDate)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Редагувати нотатку")
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
        var updatedNote = note
        updatedNote.title = title
        updatedNote.content = content
        updatedNote.folderId = selectedFolderId
        updatedNote.tags = tags
        
        viewModel.updateNote(updatedNote)
        dismiss()
    }
}
