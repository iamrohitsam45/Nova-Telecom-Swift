import SwiftUI

public enum TelecomTab: Int, CaseIterable, Identifiable, Sendable {
    case home = 0
    case products = 1
    case plans = 2
    case support = 3
    case profile = 4

    public var id: Int { rawValue }

    public var title: String {
        switch self {
        case .home: return "Home"
        case .products: return "Products"
        case .plans: return "Plans"
        case .support: return "Support"
        case .profile: return "Profile"
        }
    }

    public var iconName: String {
        switch self {
        case .home: return "house.fill"
        case .products: return "square.grid.2x2.fill"
        case .plans: return "bolt.horizontal.fill"
        case .support: return "lifepreserver.fill"
        case .profile: return "person.crop.circle.fill"
        }
    }
}

public struct CustomTabBar: View {
    @Binding public var selectedTab: TelecomTab
    public let cartItemCount: Int
    public let onCartTapped: () -> Void

    public init(
        selectedTab: Binding<TelecomTab>,
        cartItemCount: Int = 0,
        onCartTapped: @escaping () -> Void = {}
    ) {
        self._selectedTab = selectedTab
        self.cartItemCount = cartItemCount
        self.onCartTapped = onCartTapped
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(TelecomTab.allCases) { tab in
                let isSelected = selectedTab == tab

                Button(action: {
                    HapticFeedback.selection()
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                }) {
                    VStack(spacing: 4) {
                        ZStack {
                            if isSelected {
                                Circle()
                                    .fill(TelecomColors.neonCyan.opacity(0.18))
                                    .frame(width: 44, height: 44)
                                    .blur(radius: 4)
                            }

                            Image(systemName: tab.iconName)
                                .font(.system(size: 20, weight: isSelected ? .bold : .medium))
                                .foregroundColor(isSelected ? TelecomColors.neonCyan : TelecomColors.neutralMuted)
                                .scaleEffect(isSelected ? 1.15 : 1.0)
                        }

                        Text(tab.title)
                            .font(TelecomTypography.captionSmall)
                            .fontWeight(isSelected ? .bold : .regular)
                            .foregroundColor(isSelected ? .white : TelecomColors.neutralMuted)
                    }
                    .frame(maxWidth: .infinity)
                }
                .accessibilityLabel(tab.title)
                .accessibilityAddTraits(isSelected ? .isSelected : [])
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 12)
        .padding(.bottom, 24)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.07, green: 0.11, blue: 0.22).opacity(0.95),
                            Color(red: 0.04, green: 0.07, blue: 0.15).opacity(0.98)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [Color.white.opacity(0.2), Color.white.opacity(0.04)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.black.opacity(0.5), radius: 16, x: 0, y: -4)
        )
        .padding(.horizontal, 16)
    }
}
