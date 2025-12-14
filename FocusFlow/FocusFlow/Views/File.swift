import SwiftUI

struct EmptyNotesView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "note.text")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("Немає нотаток")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Додайте першу нотатку")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
