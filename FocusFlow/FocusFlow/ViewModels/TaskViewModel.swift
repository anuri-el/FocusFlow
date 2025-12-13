import Foundation
import SwiftUI

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var categories: [TaskCategory] = TaskCategory.defaultCategories
    
    init() {
        loadData()
    }
    // MARK: - Завдання
    
    func addTask(title: String, description: String, category: TaskCategory, deadline: Date?) {
        let newTask = Task(
            title: title,
            description: description,
            category: category,
            deadline: deadline
        )
        tasks.append(newTask)
        saveData()
    }
    
    func updateTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
            saveData()
        }
    }
    
    func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
        saveData()
    }
    
    func toggleTaskCompletion(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            saveData()
        }
    }
    
    // MARK: - Категорії
    
    func addCategory(name: String, color: String, icon: String) {
        let newCategory = TaskCategory(name: name, color: color, icon: icon)
        categories.append(newCategory)
        saveData()
    }
    
    func updateCategory(_ category: TaskCategory) {
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories[index] = category
            
            // Оновлюємо категорію в усіх завданнях
            for i in 0..<tasks.count {
                if tasks[i].category.id == category.id {
                    tasks[i].category = category
                }
            }
            
            saveData()
        }
    }
    
    func deleteCategory(_ category: TaskCategory) {
        categories.removeAll { $0.id == category.id }
        saveData()
    }
    
    // MARK: - Фільтрація
    
    func tasks(for category: TaskCategory?) -> [Task] {
        if let category = category {
            return tasks.filter { $0.category.id == category.id }
        }
        return tasks
    }
    
    var incompleteTasks: [Task] {
        tasks.filter { !$0.isCompleted }
    }
    
    var completedTasks: [Task] {
        tasks.filter { $0.isCompleted }
    }
    
    // MARK: - Збереження даних
    
    private func saveData() {
        // Зберігаємо завдання
        if let encodedTasks = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encodedTasks, forKey: "tasks")
        }
        
        // Зберігаємо категорії
        if let encodedCategories = try? JSONEncoder().encode(categories) {
            UserDefaults.standard.set(encodedCategories, forKey: "categories")
        }
    }
    
    private func loadData() {
        // Завантажуємо завдання
        if let savedTasks = UserDefaults.standard.data(forKey: "tasks"),
           let decodedTasks = try? JSONDecoder().decode([Task].self, from: savedTasks) {
            tasks = decodedTasks
        }
        
        // Завантажуємо категорії
        if let savedCategories = UserDefaults.standard.data(forKey: "categories"),
           let decodedCategories = try? JSONDecoder().decode([TaskCategory].self, from: savedCategories) {
            categories = decodedCategories
        }
    }
}
