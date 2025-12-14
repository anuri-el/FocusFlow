import Foundation

struct Note: Identifiable, Codable {
    var id = UUID()
    var title: String
    var content: String
    var folderId: UUID? // Папка до якої належить
    var tags: [String] = []
    var isPinned: Bool = false
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    
    // Форматовані дати
    var formattedCreatedDate: String {
        createdAt.formatted(date: .abbreviated, time: .omitted)
    }
    
    var formattedUpdatedDate: String {
        updatedAt.formatted(date: .abbreviated, time: .shortened)
    }
    
    // Попередній перегляд контенту
    var preview: String {
        let cleanContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleanContent.isEmpty {
            return "Пуста нотатка"
        }
        let maxLength = 100
        if cleanContent.count > maxLength {
            return String(cleanContent.prefix(maxLength)) + "..."
        }
        return cleanContent
    }
}
