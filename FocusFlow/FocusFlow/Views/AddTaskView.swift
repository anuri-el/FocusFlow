import SwiftUI

struct AddTaskView: View {
    @ObservedObject var viewModel: TaskViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var description = ""
    @State private var selectedCategory: TaskCategory?
    @State private var deadline = Date()
    @State private var hasDeadline = false
    
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
                                    isSelected: selectedCategory?.id == category.id
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
            }
            .navigationTitle("Нове завдання")
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
        !title.isEmpty && selectedCategory != nil
    }
    
    private func saveTask() {
        guard let category = selectedCategory else { return }
        
        viewModel.addTask(
            title: title,
            description: description,
            category: category,
            deadline: hasDeadline ? deadline : nil
        )
        
        dismiss()
    }
}
