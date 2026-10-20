import SwiftUI

public struct AnimatedWifiWaveView: View {
    public let isOnline: Bool
    public let signalBars: Int // 1 to 4
    @State private var wavePhase: CGFloat = 0.0

    public init(isOnline: Bool = true, signalBars: Int = 4) {
        self.isOnline = isOnline
        self.signalBars = signalBars
    }

    public var body: some View {
        ZStack {
            ForEach(0..<4) { index in
                let dimension = CGFloat(40 + index * 32)
                Circle()
                    .stroke(strokeColor(for: index), lineWidth: 1.5)
                    .frame(width: dimension, height: dimension)
                    .scaleEffect(isOnline ? (1.0 + wavePhase * 0.15) : 1.0)
                    .opacity(isOnline ? (1.0 - wavePhase * 0.5) : 0.6)
                    .animation(waveAnimation(for: index), value: wavePhase)
            }

            // Center Pulse Hub
            Circle()
                .fill(isOnline ? TelecomColors.neonCyan : TelecomColors.dangerRed)
                .frame(width: 16, height: 16)
                .shadow(color: isOnline ? TelecomColors.neonCyan.opacity(0.8) : TelecomColors.dangerRed.opacity(0.8), radius: 8)

            // Wi-Fi glyph
            Image(systemName: isOnline ? "wifi" : "wifi.slash")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(width: 160, height: 160)
        .onAppear {
            if isOnline {
                wavePhase = 1.0
            }
        }
    }

    private func strokeColor(for index: Int) -> Color {
        if isOnline {
            let opacity = max(0.05, 0.45 - Double(index) * 0.1)
            return TelecomColors.neonCyan.opacity(opacity)
        } else {
            return TelecomColors.dangerRed.opacity(0.2)
        }
    }

    private func waveAnimation(for index: Int) -> Animation {
        if isOnline {
            return Animation.easeOut(duration: 2.2)
                .repeatForever(autoreverses: false)
                .delay(Double(index) * 0.4)
        } else {
            return .default
        }
    }
}
