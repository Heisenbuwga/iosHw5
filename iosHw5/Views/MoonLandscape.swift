import SwiftUI

/// 向量山水：不需要網路或外部圖片，並遵從「減少動態效果」設定。
struct MoonLandscape: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var drift = false
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                LinearGradient(colors: [Color(red: 0.13, green: 0.28, blue: 0.33), Ink.background], startPoint: .top, endPoint: .bottom)
                Circle().fill(Ink.gold.opacity(0.07)).frame(width: 190, height: 190)
                    .position(x: proxy.size.width * 0.73, y: proxy.size.height * 0.29)
                    .scaleEffect(drift ? 1.10 : 0.95)
                Circle().fill(Ink.paper).frame(width: 73, height: 73)
                    .shadow(color: Ink.gold.opacity(0.3), radius: 25)
                    .position(x: proxy.size.width * 0.73, y: proxy.size.height * 0.29)
                ForEach(0..<3) { layer in
                    MountainShape(offset: CGFloat(layer) * 0.18)
                        .fill([Color(red: 0.22, green: 0.37, blue: 0.39), Color(red: 0.13, green: 0.27, blue: 0.30), Ink.background][layer])
                        .offset(x: drift ? CGFloat(layer - 1) * 8 : 0, y: CGFloat(layer) * 26 + 95)
                }
                VStack { Spacer(); Rectangle().fill(Ink.gold.opacity(0.35)).frame(width: 1, height: 42); Text("月 讀").font(.caption2).tracking(4).padding(.bottom, 20) }
                    .foregroundStyle(Ink.gold)
            }.clipped()
        }
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: true)) { drift = true }
        }
        .accessibilityHidden(true)
    }
}

private struct MountainShape: Shape {
    var offset: CGFloat
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: CGPoint(x: -20, y: rect.height))
            p.addLine(to: CGPoint(x: -20, y: rect.height * 0.45))
            for i in 0...80 {
                let x = CGFloat(i) / 80
                let y = 0.35 + sin(x * 7 + offset * 8) * 0.16 + cos(x * 17 + offset * 3) * 0.06
                p.addLine(to: CGPoint(x: x * rect.width, y: y * rect.height))
            }
            p.addLine(to: CGPoint(x: rect.width + 20, y: rect.height))
            p.closeSubpath()
        }
    }
}
