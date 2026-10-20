import SwiftUI
import Combine

@MainActor
public final class ProfileViewModel: ObservableObject {
    @Published public var showAuthModal: Bool = false
    @Published public var showEditProfile: Bool = false

    public init() {}
}
