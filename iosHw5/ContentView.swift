import SwiftUI

struct ContentView: View {
    @State private var store = ReadingStore()
    @State private var selectedTab = 0
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("漫遊", systemImage: "moon.stars", value: 0) { DiscoverView() }
            Tab("詩集", systemImage: "books.vertical", value: 1) { LibraryView(favoritesOnly: false) }
            Tab("收藏", systemImage: "bookmark", value: 2) { LibraryView(favoritesOnly: true) }
        }
        .environment(store)
        .tint(Ink.gold)
        .preferredColorScheme(.dark)
        #if DEBUG
        .task {
            if ProcessInfo.processInfo.arguments.contains("-library") { selectedTab = 1 }
            if ProcessInfo.processInfo.arguments.contains("-favorites") { selectedTab = 2 }
            if ProcessInfo.processInfo.arguments.contains("-demo") {
                try? await Task.sleep(for: .seconds(17))
                selectedTab = 1
                try? await Task.sleep(for: .seconds(3))
                selectedTab = 2
            }
        }
        #endif
    }
}

#Preview { ContentView() }
