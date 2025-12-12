import Foundation

struct TaskCategory: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var color: String // Зберігаємо як hex string
    var icon: String // SF Symbol name
    
    static let defaultCategories = [
        TaskCategory(name: "Робота", color: "blue", icon: "briefcase.fill"),
        TaskCategory(name: "Навчання", color: "green", icon: "book.fill"),
        TaskCategory(name: "Особисте", color: "purple", icon: "person.fill"),
        TaskCategory(name: "Здоров'я", color: "red", icon: "heart.fill")
    ]
}
