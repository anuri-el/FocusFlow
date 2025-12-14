import SwiftUI

struct NotesView: View {
    @StateObject private var viewModel = NoteViewModel()
    @State private var selectedFolder: NoteFolder? = nil
    @State private var showingAddNote = false
    @State private var showingFolders = false
    @State private var noteToEdit: Note? = nil
    @State private var showAllNotes = true
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Пошук
                SearchBar(text: $viewModel.searchText)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                
                // Список папок (горизонтальний скрол)
                FolderScrollView(
                    folders: viewModel.folders,
                    selectedFolder: $selectedFolder,
                    showAllNotes: $showAllNotes,
                    notesCount: { folder in
                        viewModel.notesCount(in: folder)
                    }
                )
                
                // Список нотаток
                if displayedNotes.isEmpty {
                    EmptyNotesView()
                } else {
                    List {
                        ForEach(displayedNotes) { note in
                            NoteRowView(
                                note: note,
                                onTap: { noteToEdit = note },
                                onPin: { viewModel.togglePin(note) },
                                onDelete: { viewModel.deleteNote(note) }
                            )
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Нотатки")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            showingAddNote = true
                        } label: {
                            Label("Нова нотатка", systemImage: "note.text.badge.plus")
                        }
                        
                        Button {
                            showingFolders = true
                        } label: {
                            Label("Папки", systemImage: "folder")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddNote) {
//                AddNoteView(viewModel: viewModel, folderId: selectedFolder?.id)
            }
            .sheet(item: $noteToEdit) { note in
//                EditNoteView(viewModel: viewModel, note: note)
            }
            .sheet(isPresented: $showingFolders) {
//                FolderManagementView(viewModel: viewModel)
            }
        }
    }
    
    private var displayedNotes: [Note] {
        if showAllNotes {
            return viewModel.allNotes()
        } else if let folder = selectedFolder {
            return viewModel.notes(in: folder)
        }
        return []
    }
}
