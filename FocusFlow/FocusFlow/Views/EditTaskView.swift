import SwiftUI

struct EditTaskView: View {
    @ObservedObject var viewModel: TaskViewModel
    let task: Task
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String
    @State private var description: String
    @State private var selectedCategory: TaskCategory
    @State private var deadline: Date
    @State private var hasDeadline: Bool
    
    init(viewModel: TaskViewModel, task: Task) {
        self.viewModel = viewModel
        self.task = task
        
        _title = State(initialValue: task.title)
        _description = State(initialValue: task.description)
        _selectedCategory = State(initialValue: task.category)
        _deadline = State(initialValue: task.deadline ?? Date())
        _hasDeadline = State(initialValue: task.deadline != nil)
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Назва завдання
                Section(header: Text("Назва")) {
                    TextField("Введіть назву завдання", text: $title)
                }
                
                // Опис
                Section(header: Text("Опис")) {
                    TextEditor(text: $description)
                        .frame(minHeight: 100)
                }
                
                // Категорія
                Section(header: Text("Категорія")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(viewModel.categories) { category in
                                CategoryButton(
                                    category: category,
                                    isSelected: selectedCategory.id == category.id
                                ) {
                                    selectedCategory = category
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                // Дедлайн
                Section {
                    Toggle("Встановити дедлайн", isOn: $hasDeadline)
                    
                    if hasDeadline {
                        DatePicker(
                            "Дата",
                            selection: $deadline,
                            in: Date()...,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                    }
                }
                
                // Інформація про час
                if task.timeSpent > 0 {
                    Section(header: Text("Статистика")) {
                        HStack {
                            Label("Витрачено часу", systemImage: "clock")
                            Spacer()
                            Text(task.formattedTimeSpent)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Редагувати завдання")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Скасувати") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Зберегти") {
                        saveTask()
                    }
                    .disabled(!isValid)
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    private var isValid: Bool {
        !title.isEmpty
    }
    
    private func saveTask() {
        var updatedTask = task
        updatedTask.title = title
        updatedTask.description = description
        updatedTask.category = selectedCategory
        updatedTask.deadline = hasDeadline ? deadline : nil
        
        viewModel.updateTask(updatedTask)
        dismiss()
    }
}
