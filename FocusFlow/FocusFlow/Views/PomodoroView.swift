import SwiftUI

struct PomodoroView: View {
    @StateObject private var pomodoroViewModel = PomodoroViewModel()
    @ObservedObject var taskViewModel: TaskViewModel
    @Environment(\.dismiss) var dismiss
    
    let task: Task
    
    init(taskViewModel: TaskViewModel, task: Task) {
        self.taskViewModel = taskViewModel
        self.task = task
    }
    
    var body: some View {
        ZStack {
            // Фон залежно від стану
            backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                // Заголовок
                VStack(spacing: 8) {
                    Text(pomodoroViewModel.sessionType.title)
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text(task.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                .padding(.top, 40)
                
                Spacer()
                
                // Таймер
                VStack(spacing: 24) {
                    // Круговий прогрес
                    ZStack {
                        // Фоновий круг
                        Circle()
                            .stroke(Color.white.opacity(0.2), lineWidth: 20)
                            .frame(width: 280, height: 280)
                        
                        // Прогрес
                        Circle()
                            .trim(from: 0, to: pomodoroViewModel.progress)
                            .stroke(
                                Color.white,
                                style: StrokeStyle(lineWidth: 20, lineCap: .round)
                            )
                            .frame(width: 280, height: 280)
                            .rotationEffect(.degrees(-90))
                            .animation(.linear(duration: 1), value: pomodoroViewModel.progress)
                        
                        // Час
                        VStack(spacing: 8) {
                            Text(pomodoroViewModel.formattedTime)
                                .font(.system(size: 64, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            if pomodoroViewModel.completedPomodoros > 0 {
                                HStack(spacing: 4) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.caption)
                                    Text("\(pomodoroViewModel.completedPomodoros) помодоро")
                                        .font(.caption)
                                }
                                .foregroundColor(.white.opacity(0.8))
                            }
                        }
                    }
                    
                    // Іконка стану
                    Image(systemName: pomodoroViewModel.sessionType.icon)
                        .font(.system(size: 32))
                        .foregroundColor(.white.opacity(0.6))
                }
                
                Spacer()
                
                // Кнопки керування
                VStack(spacing: 16) {
                    // Головна кнопка
                    Button(action: mainButtonAction) {
                        HStack {
                            Image(systemName: mainButtonIcon)
                                .font(.title3)
                            Text(mainButtonTitle)
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(backgroundColor)
                        .cornerRadius(16)
                    }
                    
                    // Додаткові кнопки
                    HStack(spacing: 12) {
                        if pomodoroViewModel.timerState != .idle {
                            Button(action: {
                                pomodoroViewModel.stopTimer()
                                dismiss()
                            }) {
                                HStack {
                                    Image(systemName: "stop.fill")
                                    Text("Зупинити")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                        }
                        
                        if pomodoroViewModel.isWorking {
                            Button(action: {
                                pomodoroViewModel.skipToBreak()
                            }) {
                                HStack {
                                    Image(systemName: "forward.fill")
                                    Text("До перерви")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                        }
                        
                        if pomodoroViewModel.isOnBreak {
                            Button(action: {
                                pomodoroViewModel.skipBreak()
                            }) {
                                HStack {
                                    Image(systemName: "forward.fill")
                                    Text("До роботи")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                        }
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            pomodoroViewModel.taskViewModel = taskViewModel
            if pomodoroViewModel.timerState == .idle {
                pomodoroViewModel.startTimer(for: task)
            }
        }
        .onDisappear {
            // Зберігаємо прогрес якщо таймер був активний
            if pomodoroViewModel.timerState == .running || pomodoroViewModel.timerState == .paused {
                pomodoroViewModel.pauseTimer()
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var backgroundColor: Color {
        switch pomodoroViewModel.sessionType {
        case .work:
            return Color(red: 0.9, green: 0.3, blue: 0.3) // Червоний для роботи
        case .shortBreak:
            return Color(red: 0.3, green: 0.7, blue: 0.9) // Блакитний для короткої перерви
        case .longBreak:
            return Color(red: 0.4, green: 0.6, blue: 0.9) // Синій для довгої перерви
        }
    }
    
    private var mainButtonIcon: String {
        switch pomodoroViewModel.timerState {
        case .idle:
            return "play.fill"
        case .running:
            return "pause.fill"
        case .paused:
            return "play.fill"
        case .break_:
            return "pause.fill"
        }
    }
    
    private var mainButtonTitle: String {
        switch pomodoroViewModel.timerState {
        case .idle:
            return "Почати"
        case .running:
            return "Пауза"
        case .paused:
            return "Продовжити"
        case .break_:
            return "Пауза"
        }
    }
    
    private func mainButtonAction() {
        switch pomodoroViewModel.timerState {
        case .idle:
            pomodoroViewModel.startTimer(for: task)
        case .running, .break_:
            pomodoroViewModel.pauseTimer()
        case .paused:
            pomodoroViewModel.resumeTimer()
        }
    }
}
