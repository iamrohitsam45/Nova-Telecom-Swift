import Foundation

public enum DataSizeFormatter {
    public static func formatSpeed(mbps: Int) -> String {
        if mbps >= 1000 {
            let gbps = Double(mbps) / 1000.0
            if gbps.truncatingRemainder(dividingBy: 1) == 0 {
                return "\(Int(gbps)) Gbps"
            }
            return String(format: "%.1f Gbps", gbps)
        }
        return "\(mbps) Mbps"
    }

    public static func formatData(gb: Double) -> String {
        if gb >= 1000 {
            let tb = gb / 1000.0
            return String(format: "%.1f TB", tb)
        }
        return String(format: "%.1f GB", gb)
    }
}
