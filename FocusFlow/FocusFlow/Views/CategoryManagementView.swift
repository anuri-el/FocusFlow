import SwiftUI

struct CategoryManagementView: View {
    @ObservedObject var viewModel: TaskViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showingAddCategory = false
    @State private var categoryToEdit: TaskCategory? = nil
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.categories) { category in
                    CategoryManagementRow(
                        category: category,
                        taskCount: taskCount(for: category),
                        onEdit: {
                            categoryToEdit = category
                        },
                        onDelete: {
                            viewModel.deleteCategory(category)
                        }
                    )
                }
            }
            .navigationTitle("Категорії")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Готово") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddCategory = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $showingAddCategory) {
                AddCategoryView(viewModel: viewModel)
            }
            .sheet(item: $categoryToEdit) { category in
                EditCategoryView(viewModel: viewModel, category: category)
            }
        }
    }
    
    private func taskCount(for category: TaskCategory) -> Int {
        viewModel.tasks.filter { $0.category.id == category.id }.count
    }
}
