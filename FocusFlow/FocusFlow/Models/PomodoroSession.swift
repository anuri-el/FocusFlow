import Foundation

struct PomodoroSession: Identifiable, Codable {
    var id = UUID()
    var taskId: UUID
    var startTime: Date
    var endTime: Date?
    var duration: TimeInterval // в секундах
    var wasCompleted: Bool = false
    
    var formattedDuration: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct PomodoroSettings: Codable {
    var workDuration: TimeInterval = 25 * 60 // 25 хвилин
    var shortBreakDuration: TimeInterval = 5 * 60 // 5 хвилин
    var longBreakDuration: TimeInterval = 15 * 60 // 15 хвилин
    var sessionsBeforeLongBreak: Int = 4
    
    static let `default` = PomodoroSettings()
}

enum TimerState {
    case idle
    case running
    case paused
    case break_
}

enum SessionType {
    case work
    case shortBreak
    case longBreak
    
    var title: String {
        switch self {
        case .work: return "Робота"
        case .shortBreak: return "Коротка перерва"
        case .longBreak: return "Довга перерва"
        }
    }
    
    var icon: String {
        switch self {
        case .work: return "brain.head.profile"
        case .shortBreak: return "cup.and.saucer.fill"
        case .longBreak: return "bed.double.fill"
        }
    }
}
