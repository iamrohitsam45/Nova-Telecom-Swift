import SwiftUI

@main
struct NovaTelecomApp: App {
    @StateObject private var userSession = UserSession.shared

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(userSession)
                .preferredColorScheme(.dark)
        }
    }
}
