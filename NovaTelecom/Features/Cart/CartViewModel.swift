import SwiftUI
import Combine

@MainActor
public final class CartViewModel: ObservableObject {
    @Published public var cart: Cart = DemoDataStore.shared.cart
    @Published public var promoCodeInput: String = ""
    @Published public var promoMessage: String?
    @Published public var isCheckingOut: Bool = false
    @Published public var showCheckoutView: Bool = false

    public init() {
        refresh()
    }

    public func refresh() {
        self.cart = DemoDataStore.shared.cart
    }

    public func updateQuantity(itemId: String, quantity: Int) {
        DemoDataStore.shared.updateCartItemQuantity(id: itemId, quantity: quantity)
        refresh()
    }

    public func removeItem(itemId: String) {
        DemoDataStore.shared.removeCartItem(id: itemId)
        refresh()
    }

    public func applyPromoCode() {
        HapticFeedback.light()
        let code = promoCodeInput.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if code == "NOVA50" {
            DemoDataStore.shared.cart.promoCode = code
            DemoDataStore.shared.cart.promoDiscountMinorUnits = 5000 // $50 off
            promoMessage = "Coupon NOVA50 applied: $50 discount!"
            HapticFeedback.success()
        } else if code == "FIBER10" {
            DemoDataStore.shared.cart.promoCode = code
            DemoDataStore.shared.cart.promoDiscountMinorUnits = 1000 // $10 off
            promoMessage = "Coupon FIBER10 applied: $10 discount!"
            HapticFeedback.success()
        } else {
            promoMessage = "Invalid coupon code."
            HapticFeedback.warning()
        }
        refresh()
    }
}
