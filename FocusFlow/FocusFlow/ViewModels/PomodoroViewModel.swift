import Foundation
import SwiftUI
import Combine

class PomodoroViewModel: ObservableObject {
    @Published var currentTask: Task?
    @Published var timeRemaining: TimeInterval = 0
    @Published var totalTime: TimeInterval = 0
    @Published var timerState: TimerState = .idle
    @Published var sessionType: SessionType = .work
    @Published var completedPomodoros: Int = 0
    @Published var settings = PomodoroSettings.default
    
    private var timer: AnyCancellable?
    private var sessionStartTime: Date?
    private var pausedTime: TimeInterval = 0
    
    var taskViewModel: TaskViewModel?
    
    // MARK: - Timer Controls
    
    func startTimer(for task: Task) {
        currentTask = task
        sessionType = .work
        totalTime = settings.workDuration
        timeRemaining = settings.workDuration
        timerState = .running
        sessionStartTime = Date()
        
        startTimerLoop()
    }
    
    func resumeTimer() {
        guard timerState == .paused else { return }
        timerState = .running
        sessionStartTime = Date().addingTimeInterval(-pausedTime)
        startTimerLoop()
    }
    
    func pauseTimer() {
        guard timerState == .running else { return }
        timerState = .paused
        pausedTime = totalTime - timeRemaining
        timer?.cancel()
        
        // Зберігаємо прогрес
        saveProgress()
    }
    
    func stopTimer() {
        timer?.cancel()
        
        // Зберігаємо прогрес якщо був
        if timerState == .running || timerState == .paused {
            saveProgress()
        }
        
        // Скидаємо стан
        timerState = .idle
        timeRemaining = 0
        totalTime = 0
        pausedTime = 0
        sessionStartTime = nil
        currentTask = nil
    }
    
    func skipToBreak() {
        timer?.cancel()
        
        // Зберігаємо прогрес
        if sessionType == .work {
            saveProgress(completed: true)
            completedPomodoros += 1
        }
        
        startBreak()
    }
    
    func skipBreak() {
        timer?.cancel()
        
        if let task = currentTask {
            startTimer(for: task)
        } else {
            stopTimer()
        }
    }
    
    // MARK: - Private Methods
    
    private func startTimerLoop() {
        timer?.cancel()
        
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.timerCompleted()
                }
            }
    }
    
    private func timerCompleted() {
        timer?.cancel()
        
        switch sessionType {
        case .work:
            // Зберігаємо виконаний помодоро
            saveProgress(completed: true)
            completedPomodoros += 1
            
            // Переходимо на перерву
            startBreak()
            
        case .shortBreak, .longBreak:
            // Після перерви повертаємось до роботи
            if let task = currentTask {
                startTimer(for: task)
            } else {
                stopTimer()
            }
        }
    }
    
    private func startBreak() {
        // Визначаємо тип перерви
        if completedPomodoros % settings.sessionsBeforeLongBreak == 0 && completedPomodoros > 0 {
            sessionType = .longBreak
            totalTime = settings.longBreakDuration
            timeRemaining = settings.longBreakDuration
        } else {
            sessionType = .shortBreak
            totalTime = settings.shortBreakDuration
            timeRemaining = settings.shortBreakDuration
        }
        
        timerState = .break_
        sessionStartTime = Date()
        pausedTime = 0
        
        startTimerLoop()
    }
    
    private func saveProgress(completed: Bool = false) {
        guard let task = currentTask else { return }
        
        // Обчислюємо час що минув
        let elapsedTime: TimeInterval
        if completed {
            elapsedTime = totalTime
        } else {
            elapsedTime = totalTime - timeRemaining
        }
        
        // Оновлюємо завдання
        var updatedTask = task
        updatedTask.timeSpent += elapsedTime
        
        taskViewModel?.updateTask(updatedTask)
        
        // Оновлюємо поточне завдання
        currentTask = updatedTask
    }
    
    // MARK: - Helpers
    
    var formattedTime: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var progress: Double {
        guard totalTime > 0 else { return 0 }
        return 1 - (timeRemaining / totalTime)
    }
    
    var isWorking: Bool {
        sessionType == .work && (timerState == .running || timerState == .paused)
    }
    
    var isOnBreak: Bool {
        timerState == .break_
    }
}
