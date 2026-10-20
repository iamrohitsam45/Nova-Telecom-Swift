import Foundation

public enum CurrencyFormatter {
    public static func format(minorUnits: Int, currencyCode: String = "USD") -> String {
        let amount = Double(minorUnits) / 100.0
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter.string(from: NSNumber(value: amount)) ?? String(format: "$%.2f", amount)
    }

    public static func formatCompact(minorUnits: Int, currencyCode: String = "USD") -> String {
        let amount = Double(minorUnits) / 100.0
        if amount.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "$%.0f", amount)
        } else {
            return String(format: "$%.2f", amount)
        }
    }
}
