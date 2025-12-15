import SwiftUI

struct NotesStatsView: View {
    @ObservedObject var noteViewModel: NoteViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Статистика нотаток")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            HStack(spacing: 12) {
                StatCard(
                    title: "Всього нотаток",
                    value: "\(noteViewModel.notes.count)",
                    icon: "note.text",
                    color: .purple
                )
                
                StatCard(
                    title: "Папок",
                    value: "\(noteViewModel.folders.count)",
                    icon: "folder.fill",
                    color: .orange
                )
            }
            .padding(.horizontal)
            
            // Нотатки по папках
            VStack(spacing: 8) {
                ForEach(noteViewModel.folders) { folder in
                    HStack {
                        Image(systemName: folder.icon)
                            .foregroundColor(colorFromString(folder.color))
                            .frame(width: 24)
                        
                        Text(folder.name)
                            .font(.subheadline)
                        
                        Spacer()
                        
                        Text("\(noteViewModel.notesCount(in: folder))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .padding(.horizontal)
        }
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
