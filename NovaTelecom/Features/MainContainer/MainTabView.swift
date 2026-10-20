import SwiftUI

public struct MainTabView: View {
    @State private var selectedTab: TelecomTab = .home
    @State private var showCartSheet: Bool = false

    public init() {}

    public var body: some View {
        ZStack(alignment: .bottom) {
            // Tab Content
            Group {
                switch selectedTab {
                case .home:
                    HomeView(selectedTab: $selectedTab)
                case .products:
                    ProductsView()
                case .plans:
                    PlansView()
                case .support:
                    SupportView()
                case .profile:
                    ProfileView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Custom Animated Bottom Tab Bar
            CustomTabBar(
                selectedTab: $selectedTab,
                cartItemCount: DemoDataStore.shared.cart.totalItemCount,
                onCartTapped: {
                    showCartSheet = true
                }
            )
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .sheet(isPresented: $showCartSheet) {
            CartView()
        }
    }
}
