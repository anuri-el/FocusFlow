import SwiftUI

struct TaskListView: View {
    @StateObject private var viewModel = TaskViewModel()
    @State private var showingAddTask = false
    @State private var selectedCategory: TaskCategory? = nil
    @State private var showCompletedTasks = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Фільтр категорій
                CategoryFilterView(
                    categories: viewModel.categories,
                    selectedCategory: $selectedCategory
                )
                
                // Список завдань
                if filteredTasks.isEmpty {
                    EmptyStateView()
                } else {
                    List {
                        // Активні завдання
                        if !viewModel.incompleteTasks.isEmpty {
                            Section(header: Text("Активні завдання")) {
                                ForEach(filteredTasks.filter { !$0.isCompleted }) { task in
                                    TaskRowView(
                                        task: task,
                                        onToggle: { viewModel.toggleTaskCompletion(task) },
                                        onDelete: { viewModel.deleteTask(task) }
                                    )
                                }
                            }
                        }
                        
                        // Виконані завдання
                        if showCompletedTasks && !viewModel.completedTasks.isEmpty {
                            Section(header: Text("Виконані")) {
                                ForEach(filteredTasks.filter { $0.isCompleted }) { task in
                                    TaskRowView(
                                        task: task,
                                        onToggle: { viewModel.toggleTaskCompletion(task) },
                                        onDelete: { viewModel.deleteTask(task) }
                                    )
                                    .opacity(0.6)
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
                
                Spacer()
            }
            .navigationTitle("Завдання")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddTask = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showCompletedTasks.toggle()
                    } label: {
                        Image(systemName: showCompletedTasks ? "eye.fill" : "eye.slash.fill")
                    }
                }
            }
            .sheet(isPresented: $showingAddTask) {
                AddTaskView(viewModel: viewModel)
            }
        }
    }
    
    private var filteredTasks: [Task] {
        viewModel.tasks(for: selectedCategory)
    }
}
