import Foundation

struct NoteFolder: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var icon: String
    var color: String
    var parentId: UUID? // Для вкладених папок
    
    // Стандартні папки
    static let defaultFolders = [
        NoteFolder(name: "Особисте", icon: "person.fill", color: "blue"),
        NoteFolder(name: "Робота", icon: "briefcase.fill", color: "orange"),
        NoteFolder(name: "Ідеї", icon: "lightbulb.fill", color: "yellow")
    ]
}
