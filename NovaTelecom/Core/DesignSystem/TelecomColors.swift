import SwiftUI

public enum TelecomColors {
    // Brand Primary & Accents
    public static let primaryNavy = Color(red: 0.04, green: 0.08, blue: 0.16) // #0A1429
    public static let deepNavy = Color(red: 0.02, green: 0.04, blue: 0.09) // #050B17
    public static let electricBlue = Color(red: 0.12, green: 0.44, blue: 1.0) // #1F70FF
    public static let neonCyan = Color(red: 0.0, green: 0.85, blue: 0.95) // #00D9F2
    public static let cyberViolet = Color(red: 0.58, green: 0.22, blue: 0.98) // #9438FA
    public static let glowPurple = Color(red: 0.42, green: 0.15, blue: 0.85) // #6B26D9

    // Status Colors
    public static let successGreen = Color(red: 0.13, green: 0.77, blue: 0.45) // #21C573
    public static let warningAmber = Color(red: 1.0, green: 0.65, blue: 0.15) // #FFA626
    public static let dangerRed = Color(red: 0.96, green: 0.26, blue: 0.26) // #F54242
    public static let neutralMuted = Color(red: 0.55, green: 0.60, blue: 0.68) // #8C99AD

    // Surfaces & Glassmorphism
    public static let surfaceDark = Color(red: 0.06, green: 0.10, blue: 0.20)
    public static let cardBackground = Color(red: 0.08, green: 0.13, blue: 0.24).opacity(0.85)
    public static let cardBorder = Color(red: 0.20, green: 0.35, blue: 0.65).opacity(0.35)
    public static let glassHighlight = Color.white.opacity(0.08)
    public static let glassShadow = Color.black.opacity(0.4)

    // Gradients
    public static let heroGradient = LinearGradient(
        colors: [electricBlue, cyberViolet],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    public static let cyanGlowGradient = LinearGradient(
        colors: [neonCyan, electricBlue],
        startPoint: .leading,
        endPoint: .trailing
    )

    public static let backgroundGradient = LinearGradient(
        colors: [deepNavy, primaryNavy, Color(red: 0.05, green: 0.07, blue: 0.14)],
        startPoint: .top,
        endPoint: .bottom
    )

    public static let cardGradient = LinearGradient(
        colors: [
            Color(red: 0.10, green: 0.16, blue: 0.30).opacity(0.85),
            Color(red: 0.06, green: 0.10, blue: 0.20).opacity(0.95)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    public static let signalActiveGradient = LinearGradient(
        colors: [neonCyan, successGreen],
        startPoint: .bottom,
        endPoint: .top
    )
}
