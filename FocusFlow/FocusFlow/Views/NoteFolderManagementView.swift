import SwiftUI

struct NoteFolderManagementView: View {
    @ObservedObject var viewModel: NoteViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showingAddFolder = false
    @State private var folderToEdit: NoteFolder? = nil
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.folders) { folder in
                    NoteFolderRow(
                        folder: folder,
                        notesCount: viewModel.notesCount(in: folder),
                        onEdit: {
                            folderToEdit = folder
                        },
                        onDelete: {
                            viewModel.deleteFolder(folder)
                        }
                    )
                }
            }
            .navigationTitle("Папки нотаток")
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
                        showingAddFolder = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $showingAddFolder) {
                AddNoteFolderView(viewModel: viewModel)
            }
            .sheet(item: $folderToEdit) { folder in
                EditNoteFolderView(viewModel: viewModel, folder: folder)
            }
        }
    }
}
