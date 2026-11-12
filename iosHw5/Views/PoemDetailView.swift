import SwiftUI

struct PoemDetailView: View {
    let poem: Poem
    let store: ReadingStore
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showNotes = false
    @State private var largeText = false
    @State private var appeared = false
    private var saved: Bool { store.favorites.contains(poem.id) }

    var body: some View {
        ScrollView {
            VStack(spacing: 26) {
                if sizeClass == .regular {
                    HStack(alignment: .top, spacing: 30) {
                        illustration.frame(maxWidth: .infinity)
                        readingPage.frame(maxWidth: .infinity)
                    }
                } else {
                    illustration
                    readingPage
                }
                HStack {
                    Text("唐 · \(poem.author)")
                    Spacer()
                    Text("\(String(format: "%02d", poem.id)) / 08")
                }.font(.caption).foregroundStyle(Ink.gold)
            }.padding(24).frame(maxWidth: 1100).frame(maxWidth: .infinity)
        }
        .background(Ink.background)
        .navigationTitle(poem.title).navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { withAnimation(.spring(response: 0.35)) { store.toggle(poem) } } label: {
                    Image(systemName: saved ? "bookmark.fill" : "bookmark")
                        .symbolEffect(.bounce, value: reduceMotion ? false : saved)
                }.accessibilityLabel(saved ? "取消收藏" : "收藏這首詩")
            }
        }
        .onAppear { withAnimation(reduceMotion ? nil : .easeOut(duration: 0.8)) { appeared = true } }
        #if DEBUG
        .onChange(of: store.demoShowsNotes) { _, newValue in
            guard ProcessInfo.processInfo.arguments.contains("-demo") else { return }
            withAnimation(reduceMotion ? .linear(duration: 0.1) : .spring(response: 0.55)) {
                showNotes = newValue
            }
        }
        #endif
    }

    private var illustration: some View {
        ZStack(alignment: .topLeading) {
            MoonLandscape().frame(height: sizeClass == .regular ? 480 : 200)
            VStack(alignment: .leading, spacing: 10) {
                Text(poem.theme.uppercased()).font(.caption).tracking(5).foregroundStyle(Ink.gold)
                Text(poem.title).font(.system(size: 34, weight: .light, design: .serif))
                Text("\(poem.author) / 唐").font(.subheadline).foregroundStyle(Ink.paper.opacity(0.7))
            }.padding(24)
        }.clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var readingPage: some View {
        VStack(spacing: 22) {
            HStack {
                Text(showNotes ? "字裡行間" : "詩的原文").font(.caption).tracking(3)
                Spacer()
                Button { withAnimation { largeText.toggle() } } label: { Image(systemName: "textformat.size") }
                    .accessibilityLabel(largeText ? "使用標準字體" : "放大閱讀字體")
            }.foregroundStyle(Ink.background.opacity(0.65))
            Group {
                if showNotes {
                    Text(poem.note).font(.system(size: largeText ? 25 : 20, design: .serif))
                        .lineSpacing(12).frame(maxWidth: .infinity, minHeight: 210, alignment: .topLeading)
                } else {
                    VStack(spacing: 20) {
                        ForEach(Array(poem.lines.enumerated()), id: \.offset) { index, line in
                            Text(line).font(.system(size: largeText ? 28 : 23, weight: .regular, design: .serif))
                                .multilineTextAlignment(.center)
                                .opacity(appeared ? 1 : 0).offset(y: appeared ? 0 : 12)
                                .animation(reduceMotion ? nil : .easeOut(duration: 0.6).delay(Double(index) * 0.12), value: appeared)
                        }
                    }.frame(maxWidth: .infinity, minHeight: 210)
                }
            }
            .id(showNotes)
            .transition(reduceMotion ? .opacity : .asymmetric(insertion: .offset(x: 25).combined(with: .opacity), removal: .offset(x: -25).combined(with: .opacity)))
            Rectangle().fill(Ink.background.opacity(0.15)).frame(height: 1)
            Button(action: flipPage) {
                HStack { Text(showNotes ? "返回原文" : "翻頁 · 讀賞析"); Spacer(); Image(systemName: showNotes ? "arrow.left" : "arrow.right") }
                    .font(.subheadline.weight(.medium)).padding(.vertical, 4)
            }.tint(Ink.background)
        }
        .foregroundStyle(Ink.background).padding(26)
        .background(Ink.paper, in: RoundedRectangle(cornerRadius: 16))
        .clipped()
        .rotation3DEffect(.degrees(showNotes && !reduceMotion ? -2 : 0), axis: (x: 0, y: 1, z: 0))
    }

    private func flipPage() {
        withAnimation(reduceMotion ? .linear(duration: 0.1) : .spring(response: 0.55, dampingFraction: 0.85)) { showNotes.toggle() }
    }
}
