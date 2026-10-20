import SwiftUI

public struct RouterHotspot: Identifiable, Sendable {
    public let id: String
    public let title: String
    public let subtitle: String
    public let details: String
    public let icon: String
    public let screenPosition: CGPoint // Relative normalized coordinates (0.0 to 1.0)
    public let portType: PortType

    public enum PortType: Sendable {
        case fiberSC
        case wan10G
        case lan25G
        case antennas
        case statusLEDs
        case wpsButton
        case powerDC
    }
}

public struct RouterHotspotOverlay: View {
    public let hotspots: [RouterHotspot]
    @Binding public var selectedHotspot: RouterHotspot?

    public init(hotspots: [RouterHotspot], selectedHotspot: Binding<RouterHotspot?>) {
        self.hotspots = hotspots
        self._selectedHotspot = selectedHotspot
    }

    public var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(hotspots) { spot in
                    let x = spot.screenPosition.x * geo.size.width
                    let y = spot.screenPosition.y * geo.size.height

                    Button(action: {
                        HapticFeedback.medium()
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                            if selectedHotspot?.id == spot.id {
                                selectedHotspot = nil
                            } else {
                                selectedHotspot = spot
                            }
                        }
                    }) {
                        ZStack {
                            Circle()
                                .stroke(TelecomColors.neonCyan.opacity(0.8), lineWidth: 2)
                                .frame(width: 28, height: 28)
                                .scaleEffect(selectedHotspot?.id == spot.id ? 1.3 : 1.0)

                            Circle()
                                .fill(selectedHotspot?.id == spot.id ? TelecomColors.cyberViolet : TelecomColors.electricBlue)
                                .frame(width: 20, height: 20)
                                .shadow(color: TelecomColors.neonCyan, radius: 6)

                            Image(systemName: spot.icon)
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .position(x: x, y: y)
                }

                // Callout Card when a hotspot is selected
                if let spot = selectedHotspot {
                    VStack {
                        Spacer()
                        GlassCard(cornerRadius: 18, padding: 16, hasGlow: true) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: spot.icon)
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(TelecomColors.neonCyan)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(spot.title)
                                            .font(TelecomTypography.titleSmall)
                                            .foregroundColor(.white)
                                        Text(spot.subtitle)
                                            .font(TelecomTypography.captionSmall)
                                            .foregroundColor(TelecomColors.neonCyan)
                                    }
                                    Spacer()
                                    Button(action: {
                                        withAnimation { selectedHotspot = nil }
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(TelecomColors.neutralMuted)
                                    }
                                }

                                Text(spot.details)
                                    .font(TelecomTypography.bodyMedium)
                                    .foregroundColor(.white.opacity(0.9))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 24)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
        }
    }
}
