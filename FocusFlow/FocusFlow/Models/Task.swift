import Foundation

struct Task: Identifiable, Codable {
    var id = UUID()
    var title: String
    var description: String
    var category: TaskCategory
    var deadline: Date?
    var isCompleted: Bool = false
    var timeSpent: TimeInterval = 0 // в секундах
    var createdAt: Date = Date()
    
    // Форматований час
    var formattedTimeSpent: String {
        let hours = Int(timeSpent) / 3600
        let minutes = (Int(timeSpent) % 3600) / 60
        if hours > 0 {
            return "\(hours)год \(minutes)хв"
        } else {
            return "\(minutes)хв"
        }
    }
}
