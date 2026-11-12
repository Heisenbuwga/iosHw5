import SwiftUI

struct LibraryView: View {
    let favoritesOnly: Bool
    @Environment(ReadingStore.self) private var store
    @State private var query = ""
    @State private var theme = "全部"
    private let themes = ["全部", "月色", "山水", "四季", "思念"]
    private var poems: [Poem] {
        Poem.library.filter {
            (!favoritesOnly || store.favorites.contains($0.id)) &&
            (theme == "全部" || $0.theme == theme) &&
            (query.isEmpty || ($0.title + $0.author + $0.lines.joined()).localizedStandardContains(query))
        }
    }
    var body: some View {
        NavigationStack {
            List {
                if !favoritesOnly {
                    Section {
                        Picker("主題", selection: $theme) {
                            ForEach(themes, id: \.self) { Text($0).tag($0) }
                        }.pickerStyle(.segmented).listRowBackground(Color.clear)
                    }
                }
                Section {
                    ForEach(poems) { poem in
                        NavigationLink(value: poem) {
                            HStack(spacing: 18) {
                                Image(systemName: poem.symbol).font(.title2).foregroundStyle(Ink.gold)
                                    .frame(width: 52, height: 64).background(Ink.background, in: RoundedRectangle(cornerRadius: 12))
                                VStack(alignment: .leading, spacing: 7) {
                                    Text(poem.title).font(.title3).fontDesign(.serif)
                                    Text("\(poem.author) · \(poem.theme)").font(.caption).foregroundStyle(Ink.gold)
                                    Text(poem.lines[0]).font(.subheadline).foregroundStyle(.secondary)
                                }
                                Spacer()
                                if store.favorites.contains(poem.id) { Image(systemName: "bookmark.fill").foregroundStyle(Ink.gold).accessibilityLabel("已收藏") }
                            }.padding(.vertical, 8)
                        }.listRowBackground(Ink.card)
                    }
                } header: { Text("\(favoritesOnly ? "留在心上的詩" : "唐詩選讀") · \(poems.count) 首") }
            }
            .scrollContentBackground(.hidden).background(Ink.background)
            .searchable(text: $query, prompt: "搜尋詩名、詩人或詩句")
            .overlay {
                if poems.isEmpty {
                    ContentUnavailableView(favoritesOnly && query.isEmpty ? "收藏一片月光" : "沒有符合的詩", systemImage: favoritesOnly ? "bookmark" : "magnifyingglass", description: Text(favoritesOnly && query.isEmpty ? "在閱讀頁點選書籤，喜歡的詩會留在這裡。" : "試試其他關鍵字或主題。"))
                }
            }
            .navigationTitle(favoritesOnly ? "我的收藏" : "詩集目錄")
            .navigationDestination(for: Poem.self) { poem in PoemDetailView(poem: poem) }
        }
    }
}
