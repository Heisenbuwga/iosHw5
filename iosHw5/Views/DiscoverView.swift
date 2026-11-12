import SwiftUI

struct DiscoverView: View {
    let store: ReadingStore
    @State private var path: [Poem] = []
    @Environment(\.horizontalSizeClass) private var sizeClass
    private let featured = Poem.library[0]
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(alignment: .leading, spacing: 26) {
                    HStack {
                        Text("THE MOONLIT ANTHOLOGY").font(.system(size: 10, weight: .medium)).tracking(3)
                        Spacer()
                        Text("卷 一 · 八 首").font(.caption)
                    }.foregroundStyle(Ink.gold)
                    NavigationLink(value: featured) {
                        ZStack(alignment: .bottomLeading) {
                            MoonLandscape().frame(height: sizeClass == .regular ? 410 : 350)
                            VStack(alignment: .leading, spacing: 12) {
                                Text("今夜，讀一首詩。").font(.system(size: 32, weight: .light, design: .serif))
                                Text("讓月色帶路，走進唐詩裡的山水與思念。")
                                    .font(.subheadline).foregroundStyle(Ink.paper.opacity(0.75))
                                Label("開始閱讀 · 靜夜思", systemImage: "arrow.up.right").font(.subheadline.weight(.medium))
                                    .padding(.horizontal, 18).padding(.vertical, 12)
                                    .background(Ink.paper, in: Capsule()).foregroundStyle(Ink.background)
                            }.padding(26).padding(.bottom, 24)
                        }.clipShape(RoundedRectangle(cornerRadius: 24))
                    }.buttonStyle(.plain)
                    HStack(alignment: .firstTextBaseline) {
                        Text("拾一段風景").font(.title2.weight(.medium)).fontDesign(.serif)
                        Spacer()
                        Text("慢讀 · 慢想").font(.caption).foregroundStyle(Ink.gold)
                    }
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 155), spacing: 14)], spacing: 14) {
                        ForEach(Array(Poem.library.prefix(4))) { poem in
                            NavigationLink(value: poem) {
                                VStack(alignment: .leading, spacing: 16) {
                                    HStack { Image(systemName: poem.symbol).font(.title2); Spacer(); Text(String(format: "%02d", poem.id)).font(.caption.monospaced()) }.foregroundStyle(Ink.gold)
                                    Text(poem.title).font(.title3).fontDesign(.serif)
                                    Text("\(poem.author) · \(poem.theme)").font(.caption).foregroundStyle(.secondary)
                                }.frame(maxWidth: .infinity, alignment: .leading).padding(20)
                                    .background(Ink.card, in: RoundedRectangle(cornerRadius: 18))
                            }.buttonStyle(.plain)
                        }
                    }
                    Text("一輪明月，千年的共鳴。").font(.footnote).foregroundStyle(.secondary).frame(maxWidth: .infinity).padding(.vertical)
                }.padding(22).frame(maxWidth: 1000)
                    .frame(maxWidth: .infinity)
            }.background(Ink.background)
                .navigationTitle("月讀")
                .navigationDestination(for: Poem.self) { poem in PoemDetailView(poem: poem, store: store) }
        }
        #if DEBUG
                .task {
                    if ProcessInfo.processInfo.arguments.contains("-reading") { path = [featured] }
                    if ProcessInfo.processInfo.arguments.contains("-demo") {
                        try? await Task.sleep(for: .seconds(4))
                        guard !Task.isCancelled else { return }
                        path = [featured]
                        try? await Task.sleep(for: .seconds(11))
                        guard !Task.isCancelled else { return }
                        path = []
                    }
                }
        #endif
    }
}
