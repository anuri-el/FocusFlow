import SwiftUI

struct FolderScrollView: View {
    let folders: [NoteFolder]
    @Binding var selectedFolder: NoteFolder?
    @Binding var showAllNotes: Bool
    let notesCount: (NoteFolder) -> Int
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // Кнопка "Всі нотатки"
                FolderChip(
                    name: "Всі",
                    icon: "square.grid.2x2",
                    color: .gray,
                    count: nil,
                    isSelected: showAllNotes
                ) {
                    showAllNotes = true
                    selectedFolder = nil
                }
                
                // Папки
                ForEach(folders) { folder in
                    FolderChip(
                        name: folder.name,
                        icon: folder.icon,
                        color: colorFromString(folder.color),
                        count: notesCount(folder),
                        isSelected: !showAllNotes && selectedFolder?.id == folder.id
                    ) {
                        showAllNotes = false
                        selectedFolder = folder
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .background(Color(.systemBackground))
    }
    
    private func colorFromString(_ colorName: String) -> Color {
        switch colorName {
        case "blue": return .blue
        case "green": return .green
        case "purple": return .purple
        case "red": return .red
        case "orange": return .orange
        case "pink": return .pink
        case "yellow": return .yellow
        default: return .gray
        }
    }
}
