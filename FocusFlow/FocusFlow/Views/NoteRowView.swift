import SwiftUI

struct NoteRowView: View {
    let note: Note
    let onTap: () -> Void
    let onPin: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Заголовок з іконкою пін
            HStack {
                if note.isPinned {
                    Image(systemName: "pin.fill")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
                
                Text(note.title)
                    .font(.headline)
                    .lineLimit(1)
                
                Spacer()
            }
            
            // Попередній перегляд
            Text(note.preview)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            // Теги та дата
            HStack {
                if !note.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(note.tags, id: \.self) { tag in
                                Text("#\(tag)")
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.blue.opacity(0.1))
                                    .foregroundColor(.blue)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                
                Spacer()
                
                Text(note.formattedUpdatedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Видалити", systemImage: "trash")
            }
            
            Button {
                onPin()
            } label: {
                Label(note.isPinned ? "Відкріпити" : "Закріпити",
                      systemImage: note.isPinned ? "pin.slash" : "pin")
            }
            .tint(.orange)
        }
    }
}
