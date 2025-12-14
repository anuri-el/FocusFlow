import SwiftUI

struct PomodoroSettingsView: View {
    @Binding var settings: PomodoroSettings
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Тривалість сесій")) {
                    // Робоча сесія
                    HStack {
                        Text("Робоча сесія")
                        Spacer()
                        Picker("", selection: Binding(
                            get: { Int(settings.workDuration / 60) },
                            set: { settings.workDuration = TimeInterval($0 * 60) }
                        )) {
                            ForEach([15, 20, 25, 30, 45, 60], id: \.self) { minutes in
                                Text("\(minutes) хв").tag(minutes)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    
                    // Коротка перерва
                    HStack {
                        Text("Коротка перерва")
                        Spacer()
                        Picker("", selection: Binding(
                            get: { Int(settings.shortBreakDuration / 60) },
                            set: { settings.shortBreakDuration = TimeInterval($0 * 60) }
                        )) {
                            ForEach([3, 5, 7, 10], id: \.self) { minutes in
                                Text("\(minutes) хв").tag(minutes)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    
                    // Довга перерва
                    HStack {
                        Text("Довга перерва")
                        Spacer()
                        Picker("", selection: Binding(
                            get: { Int(settings.longBreakDuration / 60) },
                            set: { settings.longBreakDuration = TimeInterval($0 * 60) }
                        )) {
                            ForEach([10, 15, 20, 25, 30], id: \.self) { minutes in
                                Text("\(minutes) хв").tag(minutes)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
                
                Section(header: Text("Цикл")) {
                    Stepper(
                        "Помодоро до довгої перерви: \(settings.sessionsBeforeLongBreak)",
                        value: $settings.sessionsBeforeLongBreak,
                        in: 2...8
                    )
                }
                
                Section {
                    Button("Скинути до стандартних") {
                        settings = PomodoroSettings.default
                    }
                }
            }
            .navigationTitle("Налаштування Pomodoro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Готово") {
                        saveSettings()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    private func saveSettings() {
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: "pomodoroSettings")
        }
    }
}
