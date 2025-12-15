import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Завдання
            TaskListView()
                .tabItem {
                    Label("Завдання", systemImage: "checklist")
                }
                .tag(0)
            
            // Нотатки
            NotesView()
                .tabItem {
                    Label("Нотатки", systemImage: "note.text")
                }
                .tag(1)
            
            // Аналітика
            AnalyticsView()
                .tabItem {
                    Label("Аналітика", systemImage: "chart.bar")
                }
                .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
