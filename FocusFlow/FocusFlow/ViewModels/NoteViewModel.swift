import Foundation
import SwiftUI

class NoteViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var folders: [NoteFolder] = NoteFolder.defaultFolders
    @Published var searchText: String = ""
    
    init() {
        loadData()
    }
    
    // MARK: - Нотатки
    
    func addNote(title: String, content: String, folderId: UUID?, tags: [String] = []) {
        let newNote = Note(
            title: title,
            content: content,
            folderId: folderId,
            tags: tags
        )
        notes.insert(newNote, at: 0) // Додаємо на початок
        saveData()
    }
    
    func updateNote(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            var updatedNote = note
            updatedNote.updatedAt = Date()
            notes[index] = updatedNote
            saveData()
        }
    }
    
    func deleteNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        saveData()
    }
    
    func togglePin(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index].isPinned.toggle()
            saveData()
        }
    }
    
    func moveNote(_ note: Note, toFolder folderId: UUID?) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index].folderId = folderId
            saveData()
        }
    }
    
    // MARK: - Папки
    
    func addFolder(name: String, icon: String, color: String, parentId: UUID? = nil) {
        let newFolder = NoteFolder(
            name: name,
            icon: icon,
            color: color,
            parentId: parentId
        )
        folders.append(newFolder)
        saveData()
    }
    
    func updateFolder(_ folder: NoteFolder) {
        if let index = folders.firstIndex(where: { $0.id == folder.id }) {
            folders[index] = folder
            saveData()
        }
    }
    
    func deleteFolder(_ folder: NoteFolder) {
        // Видаляємо всі нотатки в цій папці
        notes.removeAll { $0.folderId == folder.id }
        
        // Видаляємо вкладені папки
        let childFolders = folders.filter { $0.parentId == folder.id }
        for childFolder in childFolders {
            deleteFolder(childFolder)
        }
        
        // Видаляємо саму папку
        folders.removeAll { $0.id == folder.id }
        saveData()
    }
    
    // MARK: - Фільтрація
    
    func notes(in folder: NoteFolder?) -> [Note] {
        var filtered = notes
        
        // Фільтр по папці
        if let folder = folder {
            filtered = filtered.filter { $0.folderId == folder.id }
        }
        
        // Фільтр по пошуку
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.content.localizedCaseInsensitiveContains(searchText) ||
                $0.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }
        
        // Сортування: закріплені спочатку, потім по даті оновлення
        return filtered.sorted { note1, note2 in
            if note1.isPinned != note2.isPinned {
                return note1.isPinned
            }
            return note1.updatedAt > note2.updatedAt
        }
    }
    
    func allNotes() -> [Note] {
        var filtered = notes
        
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.content.localizedCaseInsensitiveContains(searchText) ||
                $0.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }
        
        return filtered.sorted { note1, note2 in
            if note1.isPinned != note2.isPinned {
                return note1.isPinned
            }
            return note1.updatedAt > note2.updatedAt
        }
    }
    
    func notesCount(in folder: NoteFolder) -> Int {
        notes.filter { $0.folderId == folder.id }.count
    }
    
    func childFolders(of folder: NoteFolder?) -> [NoteFolder] {
        folders.filter { $0.parentId == folder?.id }
    }
    
    // MARK: - Збереження даних
    
    private func saveData() {
        // Зберігаємо нотатки
        if let encodedNotes = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(encodedNotes, forKey: "notes")
        }
        
        // Зберігаємо папки
        if let encodedFolders = try? JSONEncoder().encode(folders) {
            UserDefaults.standard.set(encodedFolders, forKey: "noteFolders")
        }
    }
    
    private func loadData() {
        // Завантажуємо нотатки
        if let savedNotes = UserDefaults.standard.data(forKey: "notes"),
           let decodedNotes = try? JSONDecoder().decode([Note].self, from: savedNotes) {
            notes = decodedNotes
        }
        
        // Завантажуємо папки
        if let savedFolders = UserDefaults.standard.data(forKey: "noteFolders"),
           let decodedFolders = try? JSONDecoder().decode([NoteFolder].self, from: savedFolders) {
            folders = decodedFolders
        }
    }
}
