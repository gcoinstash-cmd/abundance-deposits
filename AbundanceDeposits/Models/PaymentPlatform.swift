import SwiftUI

public enum PaymentPlatform: String, CaseIterable, Identifiable, Codable {
    case stripe = "Stripe"
    case cashApp = "Cash App"
    case shopify = "Shopify"
    case payPal = "PayPal"
    case wireTransfer = "Wire Transfer"

    public var id: String { rawValue }

    public var displayName: String { rawValue }

    public var iconSymbol: String {
        switch self {
        case .stripe: return "s.square.fill"
        case .cashApp: return "dollarsign.square.fill"
        case .shopify: return "bag.fill"
        case .payPal: return "p.square.fill"
        case .wireTransfer: return "building.columns.fill"
        }
    }

    public var brandColor: Color {
        switch self {
        case .stripe:
            return Color(red: 99/255, green: 91/255, blue: 255/255) // Stripe Indigo / Purple
        case .cashApp:
            return Color(red: 0/255, green: 214/255, blue: 50/255)  // Cash App Neon Green
        case .shopify:
            return Color(red: 149/255, green: 191/255, blue: 71/255) // Shopify Light Green
        case .payPal:
            return Color(red: 0/255, green: 112/255, blue: 186/255) // PayPal Blue
        case .wireTransfer:
            return Color(red: 70/255, green: 80/255, blue: 95/255)  // Bank Slate
        }
    }

    public var defaultSoundName: String {
        switch self {
        case .stripe: return "stripe_ping"
        case .cashApp: return "cashapp_ding"
        case .shopify: return "shopify_chaching"
        case .payPal: return "paypal_alert"
        case .wireTransfer: return "bank_chime"
        }
    }

    public func generateNotification(amount: Double, sender: String, note: String? = nil) -> (title: String, body: String) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        let formattedAmount = formatter.string(from: NSNumber(value: amount)) ?? "$\(String(format: "%.2f", amount))"

        switch self {
        case .stripe:
            return (
                title: "Stripe",
                body: "You received a payment of \(formattedAmount) from \(sender)"
            )
        case .cashApp:
            let displayNote = (note?.isEmpty ?? true) ? "for Creative Services" : note!
            return (
                title: "Cash App",
                body: "\(formattedAmount) sent from $\(sender.lowercased().replacingOccurrences(of: " ", with: "_")): '\(displayNote)' 💸"
            )
        case .shopify:
            let orderNumber = Int.random(in: 1000...9999)
            return (
                title: "Shopify",
                body: "Order #\(orderNumber) • \(formattedAmount) from \(sender)"
            )
        case .payPal:
            return (
                title: "PayPal",
                body: "\(sender) just sent you \(formattedAmount)"
            )
        case .wireTransfer:
            return (
                title: "Direct Deposit",
                body: "\(formattedAmount) from \(sender) has cleared and is now available in your account."
            )
        }
    }
}
