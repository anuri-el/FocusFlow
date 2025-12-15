import SwiftUI

struct CategoryTimeData: Identifiable {
    let id = UUID()
    let category: String
    let time: TimeInterval
    let color: Color
    let percentage: Double
    
    var formattedTime: String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        if hours > 0 {
            return "\(hours)г \(minutes)хв"
        } else {
            return "\(minutes)хв"
        }
    }
}
